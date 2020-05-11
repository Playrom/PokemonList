//
//  PokeDownloader.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import UIKit

enum PokeResponse<T> {
    case success(T)
    case fail(Error)
}

enum PokeError: Error {
    case invalidResponse
    case responseNot200
    case invalidData
    case invalidJson
    case invalidSpecies
    case invalidCache
    case invalidImage
}

class PokeDownloader {
    
    private let session = URLSession.shared
    private let baseUrl = URL(string: "https://pokeapi.co/api/v2")!
    private let baseImageUrl = URL(string: "https://pokeres.bastionbot.org/images/pokemon")!
    private let cacheFolder: URL
    
    static let shared: PokeDownloader = PokeDownloader()
    
    enum Endpoint: String {
        case pokemon = "pokemon"
    }
    
    private init() {
        do {
            self.cacheFolder = try FileManager.default.url(for: .userDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
            print(error)
            self.cacheFolder = FileManager.default.temporaryDirectory
        }
    }
    
    private func getPokemonInternal<T: Codable>(url: URL, in group: DispatchGroup, completitionHandler: @escaping (T?) -> (Void)){
        group.enter()
        self.download(url) { (response: PokeResponse<T>) in
            switch response {
            case .success(let downloadedType):
                completitionHandler(downloadedType)
                group.leave()
            case .fail(_):
                completitionHandler(nil)
                group.leave()
            }
        }
    }
    
    private func getPokemonInternals<T: Codable>(types: [URL], in group: DispatchGroup, completitionHandler: @escaping (T?) -> (Void)){
        for url in types {
            self.getPokemonInternal(url: url, in: group, completitionHandler: completitionHandler)
        }
    }
    
    func getPokemon(_ id: Int, completionHandler: @escaping (PokeResponse<Pokemon>) -> Void) {
            let url = self.baseUrl.appendingPathComponent(Endpoint.pokemon.rawValue).appendingPathComponent(id.description)
            self.download(url) { (response: PokeResponse<PKPokemon>) in
                DispatchQueue.global(qos: .userInitiated).async {
                    let group = DispatchGroup()
                    switch response {
                    case .success(let jsonPokemon):
                        var pokemonTypes: [PokemonType] = []
                        var pokemonStats: [PokemonStat] = []
                        var pokemonAbilities: [PokemonAbility] = []
                        var pokemonSpecies: PokemonSpecies?
                        
                        self.getPokemonInternals(types: jsonPokemon.types.map({$0.type.url}), in: group) { (type: PokemonType?) in
                            if let type = type { pokemonTypes.append(type) }
                        }
                        
                        self.getPokemonInternals(types: jsonPokemon.stats.map({$0.stat.url}), in: group) { (stat: PokemonStat?) in
                            if var stat = stat, let originalStat = jsonPokemon.stats.first(where: {$0.stat.name == stat.name}) {
                                stat.baseStat = originalStat.baseStat
                                stat.effort = originalStat.effort
                                pokemonStats.append(stat)
                            }
                        }
                        
                        self.getPokemonInternals(types: jsonPokemon.abilities.map({$0.ability.url}), in: group) { (ability: PokemonAbility?) in
                            if var ability = ability, let originalAbility = jsonPokemon.abilities.first(where: {$0.ability.name == ability.name}) {
                                ability.isHidden = originalAbility.isHidden
                                pokemonAbilities.append(ability)
                            }
                        }
                        
                        self.getPokemonInternal(url: jsonPokemon.species.url, in: group) { (species: PokemonSpecies?) in
                            pokemonSpecies = species
                        }
                        
                        group.wait()
                        
                        guard let species = pokemonSpecies else {
                            completionHandler(.fail(PokeError.invalidSpecies))
                            return
                        }

                        let pokemon = Pokemon(id: jsonPokemon.id, name: jsonPokemon.name, height: jsonPokemon.height, weight: jsonPokemon.weight, baseExperience: jsonPokemon.baseExperience, types: pokemonTypes, stats: pokemonStats, abilities: pokemonAbilities, species: species)
                        completionHandler(.success(pokemon))
                        break
                    case .fail(let error):
                        completionHandler(.fail(error))
                    }
                    
                }
            }
    }
    
    func getImage(for pokemonId: Int, completionHandler: @escaping (UIImage?) -> Void) {
        self.download(imageFor: pokemonId) { response in
            switch response {
            case .success(let image):
                completionHandler(image)
            case .fail(_):
                completionHandler(nil)
            }
        }
    }
    
    private func cacheUrl(for url: URL, isImage: Bool) -> URL? {
        let components = Array(url.pathComponents.suffix(2))
        if components.count == 2 {
            let firstComponent = isImage ? "images" : components[0]
            return cacheFolder.appendingPathComponent(firstComponent, isDirectory: true).appendingPathComponent(components[1])
        }
        return nil
    }
    
    private func get<T: Codable>(cached url: URL, ofType type: T.Type) -> T? {
        if let cacheUrl = self.cacheUrl(for: url, isImage: false) {
            if FileManager.default.fileExists(atPath: cacheUrl.path) {
                // File in cache
                do {
                    let data = try Data(contentsOf: cacheUrl)
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(T.self, from: data)
                    return decoded
                } catch {
                    return nil
                }
            }
        }
        return nil
    }
    
    private func get(image url: URL) -> UIImage? {
        if let cacheUrl = self.cacheUrl(for: url, isImage: true),
            let image = UIImage(contentsOfFile: cacheUrl.path) {
                return image
        }
        return nil
    }
    
    @discardableResult
    private func save(_ object: Data, to url: URL, isImage: Bool) -> Bool {
        if let cacheUrl = self.cacheUrl(for: url, isImage: isImage) {
            if !FileManager.default.fileExists(atPath: cacheUrl.deletingLastPathComponent().path) {
                do {
                    try FileManager.default.createDirectory(at: cacheUrl.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
                } catch {
                    return false
                }
            }
            do {
                try object.write(to: cacheUrl, options: .atomic)
                return true
            } catch {
                return false
            }
        }
        return false
    }

    private func download<T: Codable>(_ url: URL, completionHandler: @escaping (PokeResponse<T>) -> Void) {
        
        if let cached = self.get(cached: url, ofType: T.self) {
            completionHandler(.success(cached))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                completionHandler(.fail(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.fail(PokeError.invalidResponse))
                return
            }
            
            guard response.statusCode == 200 else {
                completionHandler(.fail(PokeError.responseNot200))
                return
            }
            
            guard let data = data else {
                completionHandler(.fail(PokeError.invalidResponse))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(T.self, from: data)
                self.save(data, to: url, isImage: false)
                completionHandler(.success(decoded))
                return
            } catch {
                completionHandler(.fail(PokeError.invalidJson))
                return
            }
        }
        
        task.resume()
    }
    
    private func download(imageFor pokemonId: Int, completionHandler: @escaping (PokeResponse<UIImage>) -> Void) {
        let imageUrl = self.baseImageUrl.appendingPathComponent("\(pokemonId.description).png")
        if let cached = self.get(image: imageUrl){
            completionHandler(.success(cached))
            return
        }
        
        let task = session.dataTask(with: imageUrl) { data, response, error in
            if let error = error {
                print(error)
                completionHandler(.fail(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.fail(PokeError.invalidResponse))
                return
            }
            
            guard response.statusCode == 200 else {
                completionHandler(.fail(PokeError.responseNot200))
                return
            }
            
            guard let data = data else {
                completionHandler(.fail(PokeError.invalidResponse))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completionHandler(.fail(PokeError.invalidImage))
                return
            }

            self.save(data, to: imageUrl, isImage: true)
            completionHandler(.success(image))
        }
        
        task.resume()
    }
    
    
    
}
