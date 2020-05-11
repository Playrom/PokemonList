//
//  HeaderPokemonViewModel.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import UIKit

struct PokemonViewModel {
    var pokemonName: String
    var pokemonType1: String?
    var pokemonType2: String?
    var pokemonImage: UIImage?
    
    init(pokemonName: String, pokemonType1: String?, pokemonType2: String?, pokemonImage: UIImage?) {
        self.pokemonName = pokemonName
        self.pokemonType1 = pokemonType1
        self.pokemonType2 = pokemonType2
        self.pokemonImage = pokemonImage
    }
    
    init(pokemon: Pokemon, image: UIImage?) {
        var type1: String?
        var type2: String?
        if pokemon.types.count > 0 {
            type1 = pokemon.types[0].localizedName(for: "it")
        }

        if pokemon.types.count > 1 {
           type2 = pokemon.types[1].localizedName(for: "it")
        }

        self.init(
            pokemonName: pokemon.species.localizedName(for: "it") ?? pokemon.name,
            pokemonType1: type1,
            pokemonType2: type2,
            pokemonImage: image
        )
    }
}
