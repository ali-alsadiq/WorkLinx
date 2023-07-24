//
//  UserProfileCell.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-23.
//

import Foundation
import UIKit

class UserProfileCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEnabled = false
        textField.textAlignment = .right
        textField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true // Adjust the width as needed
        return textField
    }()
    
    lazy var cellStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.addArrangedSubview(titleLabel)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stack.addArrangedSubview(spacer)
        
        stack.addArrangedSubview(textField)
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
    
    func updateView(title: String?, value: String?, isEditing: Bool) {
        titleLabel.text = title ?? "" // Use empty string if title is nil
        textField.text = value ?? "" // Use empty string if value is nil
        textField.isEnabled = titleLabel.text == "Position" ? Utils.isAdmin && isEditing : isEditing
    }
}
