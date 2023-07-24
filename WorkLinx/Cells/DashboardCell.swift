//
//  DashboardCell.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-15.
//

import Foundation
import UIKit

class DashboardCell: UITableViewCell {
    private var userInput: [String?] = []

    lazy var cellNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.textColor = .darkGray
        
        let diameter: CGFloat = 40
        
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.cornerRadius = diameter / 2
        label.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: diameter),
            label.heightAnchor.constraint(equalToConstant: diameter)
        ])
        
        return label
    }()

    
    lazy var cellText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    lazy var extendIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints=false
        iv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iv.layer.cornerRadius = 30
        return iv
    }()
    
    lazy var cellStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.addArrangedSubview(cellNumber)
        stack.addArrangedSubview(cellText)
        
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        contentView.addSubview(cellStack)
        
        // Set padding constraints for the cell stack
        cellStack.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 10
        
        // Set constraints to center the stack view vertically within the cell
        NSLayoutConstraint.activate([
            cellStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            cellStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
        
    }
    
    func updateView(number: Int, text: String) {
        cellNumber.text = String(number)
        cellText.text = text
        extendIcon.image = UIImage(systemName: "chevron.right")
    }
    

    
    
}
