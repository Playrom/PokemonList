//
//  StatCell.swift
//  PokemonList
//
//  Created by Giorgio Romano on 11/05/2020.
//  Copyright © 2020 Giorgio Romano. All rights reserved.
//

import UIKit

class StatCell: UITableViewCell {
    
    lazy var statNameLabel: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .headline)
        view.textColor = .label
        view.numberOfLines = 0
        return view
    }()
    
    lazy var statBaseLabel: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .subheadline)
        view.textColor = .label
        return view
    }()
    
    lazy var statEffortLabel: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .subheadline)
        view.textColor = .label
        return view
    }()
    
    lazy var statBaseValueLabel: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.textColor = .secondaryLabel
        return view
    }()
    
    lazy var statEffortValueLabel: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.textColor = .secondaryLabel
        return view
    }()
    
    lazy var mainStack: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 8
        return view
    }()
    
    lazy var horizontalStack: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = 8
        return view
    }()
    
    lazy var verticalLeadingStack: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 8
        return view
    }()
    
    lazy var verticalTrailingStack: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .trailing
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
        self.statBaseLabel.text = "Valore Base"
        self.statEffortLabel.text = "Costo"

        self.verticalLeadingStack.addArrangedSubview(statBaseLabel)
        self.verticalLeadingStack.addArrangedSubview(statBaseValueLabel)
        
        self.verticalTrailingStack.addArrangedSubview(statEffortLabel)
        self.verticalTrailingStack.addArrangedSubview(statEffortValueLabel)
        
        self.horizontalStack.addArrangedSubview(self.verticalLeadingStack)
        self.horizontalStack.addArrangedSubview(self.verticalTrailingStack)
        
        self.mainStack.addArrangedSubview(statNameLabel)
        self.mainStack.addArrangedSubview(horizontalStack)
        
        self.contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            self.statNameLabel.leadingAnchor.constraint(equalTo: self.mainStack.leadingAnchor, constant: 0),
            self.statNameLabel.trailingAnchor.constraint(equalTo: self.mainStack.trailingAnchor, constant: 0),
            self.horizontalStack.widthAnchor.constraint(equalTo: self.statNameLabel.widthAnchor, multiplier: 1),
            
            self.mainStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.mainStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.mainStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            self.mainStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
        ])
    }

    override func prepareForReuse() {
        self.statNameLabel.text = nil
        self.statBaseValueLabel.text = nil
        self.statEffortValueLabel.text = nil
    }
    
    func configure(with model: StatViewModel) {
        self.statNameLabel.text = model.name
        self.statBaseValueLabel.text = model.baseValue
        self.statEffortValueLabel.text = model.effort
    }

}
