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
        return view
    }()
    
    lazy var horizontalStack: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        return view
    }()
    
    lazy var verticalLeadingStack: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        return view
    }()
    
    lazy var verticalTrailingStack: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .trailing
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with stat: PokemonStat) {
        self.statNameLabel.text = stat.localizedName(for:  "it")
        
        self.statBaseLabel.text = "Valore Base"
        self.statBaseValueLabel.text = stat.baseStat.description
        
        self.statEffortLabel.text = "Costo"
        self.statEffortValueLabel.text = stat.effort.description
    }

}
