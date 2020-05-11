//
//  Router.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import UIKit

class Router {
    var rootViewController: UIViewController?
    
    var navigationViewController: UINavigationController? {
        return self.rootViewController as? UINavigationController
    }
    
    func present(_ pokemon: Pokemon, with image: UIImage?) {
        let pokemonController = PokemonTableViewController(pokemon: pokemon, image: image)
        self.navigationViewController?.pushViewController(pokemonController, animated: true)
    }
}
