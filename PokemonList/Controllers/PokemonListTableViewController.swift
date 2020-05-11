//
//  ViewController.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import UIKit

class PokemonListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        PokeDownloader.shared.getPokemon(1) { response in
            switch response {
            case .success( let type ):
                 print(type)
            case .fail:
                break
            }
        }
    }


}

