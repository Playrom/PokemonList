//
//  PokemonTableViewController.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import UIKit

class PokemonTableViewController: UITableViewController {
    
    enum ReuseIdentifier: String {
        case header
        case description
        case ability
        case stat
    }

    var pokemon: Pokemon?
    var image: UIImage?
    
    init(pokemon: Pokemon?, image: UIImage?) {
        self.pokemon = pokemon
        self.image = image
        super.init(style: .plain)
    }
    
    func configure(pokemon: Pokemon?, image: UIImage?) {
        self.pokemon = pokemon
        self.image = image
        self.navigationItem.title = pokemon?.species.localizedName(for: "it")
        self.tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(HeaderPokemonCell.self, forCellReuseIdentifier: ReuseIdentifier.header.rawValue)
        self.tableView.register(DescriptionCell.self, forCellReuseIdentifier: ReuseIdentifier.description.rawValue)
        self.tableView.register(AbilityCell.self, forCellReuseIdentifier: ReuseIdentifier.ability.rawValue)
        self.tableView.register(StatCell.self, forCellReuseIdentifier: ReuseIdentifier.stat.rawValue)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pokemon = pokemon else {
            return 0
        }
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return pokemon.abilities.count
        case 3:
            return pokemon.stats.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "Descrizione"
        case 2:
            return "Abilitá"
        case 3:
            return "Statistiche"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.header.rawValue, for: indexPath) as? HeaderPokemonCell,
                let pokemon = pokemon else {
                return UITableViewCell()
            }
            cell.configure(with: pokemon, image: self.image)
            return cell
        case 1:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.description.rawValue, for: indexPath) as? DescriptionCell,
                let pokemon = pokemon else {
                return UITableViewCell()
            }
            cell.configure(with: pokemon)
            return cell
        case 2:
           guard let cell = self.tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ability.rawValue, for: indexPath) as? AbilityCell,
               let pokemon = pokemon else {
               return UITableViewCell()
           }
           cell.configure(with: pokemon.abilities[indexPath.row])
           return cell
       case 3:
          guard let cell = self.tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.stat.rawValue, for: indexPath) as? StatCell,
              let pokemon = pokemon else {
              return UITableViewCell()
          }
          cell.configure(with: pokemon.stats[indexPath.row])
          return cell
        default:
            return UITableViewCell()
        }
    }

}
