//
//  AbilityCell.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import UIKit

class AbilityCell: UITableViewCell {
    
    lazy var abilityNameLabel: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .headline)
        view.textColor = .label
        view.numberOfLines = 0
        return view
    }()
    
    lazy var abilityDescriptionlabel: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.textColor = .secondaryLabel
        view.numberOfLines = 0
        return view
    }()
    
    lazy var verticalStack: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 8
        return view
    }()
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.verticalStack.addArrangedSubview(abilityNameLabel)
        self.verticalStack.addArrangedSubview(abilityDescriptionlabel)
        
        self.contentView.addSubview(verticalStack)
        
        NSLayoutConstraint.activate([
            self.verticalStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.verticalStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.verticalStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            self.verticalStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
        ])
    }
    
    func configure(with model: AbilityViewModel) {
        self.abilityNameLabel.text = model.name
        self.abilityDescriptionlabel.text = model.description
    }
    
    override func prepareForReuse() {
        self.abilityNameLabel.text = nil
        self.abilityDescriptionlabel.text = nil
    }

}
