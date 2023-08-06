//
//  EmptyListMessageView.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-05.
//

import Foundation
import UIKit

class EmptyListMessageView: UIView {
    var arrowImageView: UIImageView!
    
    init(message: String) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        layer.cornerRadius = 8.0
        translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .gray
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        arrowImageView = UIImageView(image: UIImage(systemName: "arrow.turn.right.up"))
        arrowImageView.tintColor = .darkGray
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            arrowImageView.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            arrowImageView.widthAnchor.constraint(equalToConstant: 50),
            arrowImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
