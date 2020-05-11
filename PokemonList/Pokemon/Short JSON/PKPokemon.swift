//
//  PokePokemon.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import Foundation

struct PKPokemon: Codable {
    
    struct PKType: Codable {
        var slot: Int
        var type: PKUrl
    }
    
    struct PKAbility: Codable {
        var slot: Int
        var isHidden: Bool
        var ability: PKUrl
        
        enum CodingKeys: String, CodingKey {
            case slot
            case isHidden = "is_hidden"
            case ability
        }
    }
    
    struct PKStat: Codable {
        var baseStat: Double
        var effort: Double
        var stat: PKUrl
        
        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case effort
            case stat
        }
    }
    
    var id: Int
    var height: Double
    var weight: Double
    var name: String
    var baseExperience: Double
    
    var types: [PKType]
    var stats: [PKStat]
    var abilities: [PKAbility]
    var species: PKUrl
    
    enum CodingKeys: String, CodingKey {
        case id
        case height
        case weight
        case name
        case baseExperience = "base_experience"
        case types
        case stats
        case abilities
        case species
    }
}

