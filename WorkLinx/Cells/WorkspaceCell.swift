//
//  WorkplaceCell.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-20.
//

import Foundation
import UIKit

class WorkspaceCell: UITableViewCell {
    
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
    
    lazy var workSpace: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    lazy var userType: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    lazy var cellStack: UIStackView = {
        let mainStack = UIStackView()
        
        mainStack.addArrangedSubview(cellIcon)
        
        mainStack.axis = .horizontal
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.spacing = 10
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.spacing = 5
        
        vStack.addArrangedSubview(workSpace)
        vStack.addArrangedSubview(userType)
        
        mainStack.addArrangedSubview(vStack)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        mainStack.addArrangedSubview(spacer)
        
       
        mainStack.alignment = .leading
        mainStack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        mainStack.alignment = .center
        
        return mainStack
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
    
    func updateView(workspace: Workspace, user: String) {
        cellIcon.image = UIImage(systemName: "homekit")
        workSpace.text = workspace.name
        userType.text = user
    }
}
