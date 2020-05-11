//
//  PKList.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import Foundation

struct PKList: Codable {
    var count: Int
    var next: URL?
    var previous: URL?
    var results: [PKUrl]
}
