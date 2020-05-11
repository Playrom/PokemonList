//
//  PokeCacher.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import UIKit

// To reduce load on the remote api ( 100 calls/minute ) this project use a caching system
class PokeCacher {
    
    private let cacheFolder: URL
    static let shared: PokeCacher = PokeCacher()
    
    private init() {
        // PokeCacher use the app cache folder if present, otherwise use temporary directory
        do {
            self.cacheFolder = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
            print(error)
            self.cacheFolder = FileManager.default.temporaryDirectory
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
    
    func get<T: Codable>(cached url: URL, ofType type: T.Type) -> T? {
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
    
    func get(image url: URL) -> UIImage? {
        if let cacheUrl = self.cacheUrl(for: url, isImage: true),
            let image = UIImage(contentsOfFile: cacheUrl.path) {
                return image
        }
        return nil
    }
    
    @discardableResult
    func save(_ object: Data, to url: URL, isImage: Bool) -> Bool {
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

}
