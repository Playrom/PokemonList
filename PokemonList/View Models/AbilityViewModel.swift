//
//  AbilityModel.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import UIKit

struct AbilityViewModel {
    var name: String
    var description: String
    
    init(ability: PokemonAbility) {
        self.name = ability.localizedName(for: "it") ?? ability.name
        self.description = ability.localizedFlavorText(for: "it") ?? "Nessuna description"
    }
}
