//
//  PokeProtocols.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import Foundation

protocol Nameable {
    var name: String { get }
    var names: [PokemonLanguage] { get }
}

extension Nameable {
    func localizedName(for language: String) -> String? {
        let found = self.names.first { (searchingLanguage) -> Bool in
            return searchingLanguage.language.name == language
        }
        return found?.name
    }
}

protocol Flavorable {
    var flavorTextEntries: [PokemonFlavor] { get }
}

extension Flavorable {
    func localizedFlavorText(for language: String) -> String? {
        let found = self.flavorTextEntries.first { (searchingLanguage) -> Bool in
            return searchingLanguage.language.name == language
        }
        return found?.flavorText
    }
}
