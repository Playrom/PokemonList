//
//  PokeStat.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import Foundation

struct PokemonStat: Codable, Nameable {
    var id: Int
    var name: String
    var names: [PokemonLanguage]
    var gameIndex: Int
    var isBattleOnly: Bool
    var baseStat: Double = 0
    var effort: Double = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case names
        case gameIndex = "game_index"
        case isBattleOnly = "is_battle_only"
    }
}
