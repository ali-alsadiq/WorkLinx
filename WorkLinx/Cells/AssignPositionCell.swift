//
//  AssignPositionCell.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-01.
//

import UIKit

class AssignPositionCell: UITableViewCell {
    let firstNameLabel = UILabel()
    let lastNameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Customize the appearance of firstNameLabel
        firstNameLabel.textColor = UIColor.black
        firstNameLabel.font = UIFont.systemFont(ofSize: 16)
        // Add the firstNameLabel to the cell's contentView
        contentView.addSubview(firstNameLabel)

        // Customize the appearance of lastNameLabel
        lastNameLabel.textColor = UIColor.black
        lastNameLabel.font = UIFont.systemFont(ofSize: 16)
        // Add the lastNameLabel to the cell's contentView
        contentView.addSubview(lastNameLabel)

        // Add constraints to position the labels within the cell
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            firstNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lastNameLabel.leadingAnchor.constraint(equalTo: firstNameLabel.trailingAnchor, constant: 8),
            lastNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

