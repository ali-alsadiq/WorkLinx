//
//  CreateWorkspaceCell.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-20.
//

import Foundation
import UIKit

class CreateWorkplaceCell: UITableViewCell {
    
    lazy var cellText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    lazy var cellIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints=false
        iv.heightAnchor.constraint(equalToConstant: 45).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 45).isActive = true
        iv.layer.cornerRadius = 55
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .darkGray
        return iv
    }()
    
    lazy var extendIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints=false
        iv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iv.layer.cornerRadius = 30
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .darkGray
        return iv
    }()
    
    lazy var cellStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
                
        stack.addArrangedSubview(cellIcon)
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
        
        NSLayoutConstraint.activate([
            cellStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            cellStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    func updateView(cellText: String, icon: UIImage) {
        self.cellText.text = cellText
        cellIcon.image = icon
    }
}
