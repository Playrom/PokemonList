//
//  DescriptionCell.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {
    
    lazy var descriptionLabel: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.textColor = .label
        view.numberOfLines = 0
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
        
        self.contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.descriptionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with pokemon: Pokemon) {
        self.descriptionLabel.text = pokemon.species.localizedFlavorText(for: "it")
    }

}
