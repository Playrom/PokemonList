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
    
    private let cacher = PokeCacher.shared
    static let shared: PokeDownloader = PokeDownloader()
    
    enum Endpoint: String {
        case pokemon = "pokemon"
    }
    
    private init() {
        
    }
    
    private func getPokemonInternal<T: Codable>(url: URL, in group: DispatchGroup, completitionHandler: @escaping (T?) -> (Void)){
        group.enter()
        self.download(url, useCache: true) { (response: PokeResponse<T>) in
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
    
    /// Get all the pokemons from the remote list, within the offset and limit range
    /// - Parameters:
    ///   - offset: starting position of the list
    ///   - limit: maximum number of pokemon to retrieve
    ///   - completionHandler: manage the results of the request
    func getPokemons(offset: Int, limit: Int, completionHandler: @escaping (PokeResponse<[Pokemon]>) -> Void) {
        let url = self.baseUrl.appendingPathComponent(Endpoint.pokemon.rawValue)
            .appending("offset", value: offset.description)
            .appending("limit", value: limit.description)
        
        self.download(url, useCache: false) { (response: PokeResponse<PKList>) in
            DispatchQueue.global(qos: .userInitiated).async {
                let group = DispatchGroup()
                switch response {
                case .success(let json):
                    var pokemons: [Pokemon] = []
                    
                    for pokeurl in json.results {
                        group.enter()
                        // After getting a list of all the pokemon urls inside this api request
                        // Get every pokemon with all it attributes
                        self.getPokemon(pokeurl.url) { (pokemonResponse: PokeResponse<Pokemon>) in
                            switch pokemonResponse {
                            case .success(let pokemon):
                                pokemons.append(pokemon)
                            default:
                                break
                            }
                            group.leave()
                        }
                    }
                    
                    // Wait until all the pokemons are fully loaded
                    // In case of error the pokemon is discarded and the return pokemon list will be shorter
                    group.wait()
                    
                    completionHandler(.success(pokemons))
                    break
                case .fail(let error):
                    completionHandler(.fail(error))
                }
                
            }
        }
    }
    
    /// Get all the attributes for a single pokemon
    /// - Parameters:
    ///   - url: url of the remote endpoint
    ///   - completionHandler: manage the result of the request
    func getPokemon(_ url: URL, completionHandler: @escaping (PokeResponse<Pokemon>) -> Void) {
            self.download(url, useCache: true) { (response: PokeResponse<PKPokemon>) in
                DispatchQueue.global(qos: .userInitiated).async {
                    let group = DispatchGroup()
                    switch response {
                    case .success(let jsonPokemon):
                        var pokemonTypes: [PokemonType] = []
                        var pokemonStats: [PokemonStat] = []
                        var pokemonAbilities: [PokemonAbility] = []
                        var pokemonSpecies: PokemonSpecies?
                        
                        // Every pokemon model is composed of multiple attributes that must be requested
                        // with different api calls to the service.
                        // getPokemonInternals is used to obtain those values in an asynchronus way
                        
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
                        
                        // Wait for all the asynchronus call to end, in order to have all the pokemon attributes ready to use
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
    
    private func download<T: Codable>(_ url: URL, useCache: Bool, completionHandler: @escaping (PokeResponse<T>) -> Void) {
        
        // To reduce load on the remote api ( 100 calls/minute ) this project use a caching system
        if useCache, let cached = self.cacher.get(cached: url, ofType: T.self) {
            completionHandler(.success(cached))
            return
        }
        
        self.download(url: url) { response in
            switch response {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    self.cacher.save(data, to: url, isImage: false)
                    completionHandler(.success(decoded))
                    return
                } catch {
                    completionHandler(.fail(PokeError.invalidJson))
                    return
                }
            case .fail(let error):
                completionHandler(.fail(error))
            }
        }
    }
    
    private func download(imageFor pokemonId: Int, completionHandler: @escaping (PokeResponse<UIImage>) -> Void) {
        let imageUrl = self.baseImageUrl.appendingPathComponent("\(pokemonId.description).png")
        
        // To reduce load on the remote api ( 100 calls/minute ) this project use a caching system
        if let cached = self.cacher.get(image: imageUrl){
            completionHandler(.success(cached))
            return
        }
        
        self.download(url: imageUrl) { response in
            switch response {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completionHandler(.fail(PokeError.invalidImage))
                    return
                }

                self.cacher.save(data, to: imageUrl, isImage: true)
                completionHandler(.success(image))
            case .fail(let error):
                completionHandler(.fail(error))
            }
        }
    }
    
    private func download(url: URL, completionHandler: @escaping (PokeResponse<Data>) -> Void) {
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

            completionHandler(.success(data))
        }
        
        task.resume()
    }
}
