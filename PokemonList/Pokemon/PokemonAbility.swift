//
//  PokemonAbility.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import Foundation

struct PokemonAbility: Codable, Nameable, Flavorable {
    var id: Int
    var name: String
    var names: [PokemonLanguage]
    var isHidden: Bool = false
    var flavorTextEntries: [PokemonFlavor]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case names
        case flavorTextEntries = "flavor_text_entries"
    }
}
