//
//  ViewController.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import UIKit

class PokemonListTableViewController: UITableViewController {
    
    enum ReuseIdentifier: String {
        case standard
    }
    
    var router: Router
    
    private var pokemons: [Pokemon] = []
    private var cachedImages: [Int: UIImage] = [:]
    private var offset = 0
    private var isInfiniteScrollLocked = true
    
    init(with router: Router) {
        self.router = router
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Pokemon"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.largeContentTitle = "Pokemon"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.tableView.register(PokemonCell.self, forCellReuseIdentifier: ReuseIdentifier.standard.rawValue)
        
        self.loadData()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = self.pokemons[indexPath.row]
        let image = self.cachedImages[pokemon.id]
        self.router.present(pokemon, with: image)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.standard.rawValue, for: indexPath) as? PokemonCell else {
            return UITableViewCell()
        }
        let pokemon = self.pokemons[indexPath.row]
        if let image = cachedImages[pokemon.id] {
            cell.configure(with: PokemonViewModel(pokemon: pokemon, image: image))
        } else {
            cell.configure(with: PokemonViewModel(pokemon: pokemon, image: nil))
        }
        return cell
    }
    
    // Fetch an image and then reload the table
    private func downloadImage(for pokemonId: Int) {
        PokeDownloader.shared.getImage(for: pokemonId) { image in
            if let img = image {
                self.cachedImages[pokemonId] = img
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // If the content bottom position is 200 points before bottom then load another page of the api
        // This effect appens only when no download are already in background
        // To prevent multiple triggers before the add of the rows
        if !isInfiniteScrollLocked {
            let currentPosition = scrollView.contentOffset.y + scrollView.frame.height
            let refreshHeight = scrollView.contentSize.height - 200
            if currentPosition >= refreshHeight {
                self.loadData()
            }
        }
    }
    
    func loadData() {
        self.isInfiniteScrollLocked = true
        PokeDownloader.shared.getPokemons(offset: self.offset, limit: 20) { response in
            switch response {
            case .success(let newPokemons):
                guard newPokemons.count > 0 else {
                    break
                }
                let firstNewRow = self.pokemons.count
                self.pokemons.append(contentsOf: newPokemons)
                var paths = [IndexPath]()
                for (index, _) in newPokemons.enumerated() {
                    paths.append(IndexPath(row: firstNewRow + index, section: 0))
                }
                DispatchQueue.main.async {
                    self.tableView.insertRows(at: paths, with: .automatic)
                    self.isInfiniteScrollLocked = false
                    self.offset = self.offset + 20
                }
                
                for pokemon in newPokemons {
                    self.downloadImage(for: pokemon.id)
                }
                
            case .fail(_):
                break
            }
        }
    }

}

