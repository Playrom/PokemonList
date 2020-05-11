//
//  HeaderPokemonCell.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import UIKit

class HeaderPokemonCell: UITableViewCell {

    lazy var pokemonImageView: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var pokemonNameLabel: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        view.textColor = .label
        view.numberOfLines = 0
        return view
    }()
    
    lazy var pokemonType1Label: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .headline)
        view.textColor = .secondaryLabel
        return view
    }()
    
    lazy var pokemonType2Label: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .headline)
        view.textColor = .secondaryLabel
        return view
    }()
    
    lazy var mainStack: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .top
        return view
    }()
    
    lazy var verticalStack: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        return view
    }()
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup() {
        self.verticalStack.addArrangedSubview(pokemonNameLabel)
        self.verticalStack.addArrangedSubview(pokemonType1Label)
        self.verticalStack.addArrangedSubview(pokemonType2Label)
        
        self.mainStack.addArrangedSubview(verticalStack)
        self.mainStack.addArrangedSubview(pokemonImageView)
        
        self.contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            self.pokemonImageView.widthAnchor.constraint(equalToConstant: 150),
            self.pokemonImageView.heightAnchor.constraint(equalToConstant: 150),
            
            self.mainStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.mainStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.mainStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            self.mainStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with pokemon: Pokemon, image: UIImage?) {
        self.pokemonNameLabel.text = pokemon.species.localizedName(for: "it")
        
        if pokemon.types.count > 0 {
            self.pokemonType1Label.text = pokemon.types[0].localizedName(for: "it")
        }
        
        if pokemon.types.count > 1 {
            self.pokemonType2Label.text = pokemon.types[1].localizedName(for: "it")
        }
        
        self.pokemonImageView.image = image
    }

}
