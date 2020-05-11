//
//  DescriptionModel.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import UIKit

struct DescriptionViewModel {
    var pokemonDescription: String
    
    init(pokemonDescription: String) {
        self.pokemonDescription = pokemonDescription
    }
    
    init(pokemon: Pokemon) {
        self.init(pokemonDescription: pokemon.species.localizedFlavorText(for: "it") ?? "Nessuna descrizione")
    }
}
