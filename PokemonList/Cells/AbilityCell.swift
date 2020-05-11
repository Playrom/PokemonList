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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with ability: PokemonAbility) {
        self.abilityNameLabel.text = ability.localizedName(for: "it")
        self.abilityDescriptionlabel.text = ability.localizedFlavorText(for: "it")
    }

}
