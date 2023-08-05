//
//  CustomButton.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-06-27.
//

import UIKit

class CustomButton: UIButton {
    
    init(label: String) {
        super.init(frame: .zero)
        
        setTitle(label, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        setTitleColor(.white, for: .normal)
        backgroundColor = .darkGray
        layer.cornerRadius = 15
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

