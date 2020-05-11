//
//  StatModel.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import UIKit

struct StatViewModel {
    var name: String
    var baseValue: String
    var effort: String
    
    init(stat: PokemonStat) {
        self.name = stat.localizedName(for: "it") ?? stat.name
        self.baseValue = stat.baseStat.description
        self.effort = stat.effort.description
    }
}
