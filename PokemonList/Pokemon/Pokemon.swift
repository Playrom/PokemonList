//
//  Pokemon.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
    
    var id: Int
    var name: String

    var height: Double
    var weight: Double
    var baseExperience: Double
    
    var types: [PokemonType]
    var stats: [PokemonStat]
    var abilities: [PokemonAbility]
    var species: PokemonSpecies
}
