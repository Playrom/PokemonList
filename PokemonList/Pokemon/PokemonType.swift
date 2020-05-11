//
//  PokeType.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import Foundation

struct PokemonType: Codable, Nameable {
    var id: Int
    var name: String
    var names: [PokemonLanguage]
}
