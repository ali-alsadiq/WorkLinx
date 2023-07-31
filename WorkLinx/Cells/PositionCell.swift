//
//  PositionCell.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-31.
//

import Foundation
import UIKit

class PositionCell: UITableViewCell {
    
    private lazy var positionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var extendIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints=false
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.layer.cornerRadius = 30
        return iv
    }()
    
    lazy var cellStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.addArrangedSubview(positionLabel)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stack.addArrangedSubview(spacer)
        
        stack.addArrangedSubview(extendIcon)
        stack.alignment = .leading
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stack.alignment = .center
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(cellStack)
        
        cellStack.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 10
        
        // Set constraints to center the cellStack horizontally and vertically within the cell
        NSLayoutConstraint.activate([
            cellStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            cellStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            cellStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            cellStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    func updateView(position: String) {
        positionLabel.text = position
    }
}

