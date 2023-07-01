//
//  CustomTextField.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-06-27.
//

import UIKit

class CustomTextField: UITextField {
    
    private let textMargin: CGFloat = 24
    
    init(placeholder: String, textContentType: UITextContentType) {
        super.init(frame: .zero)
        
        // Set placeholder text
        self.placeholder = placeholder
        
        // Set text content type
        self.textContentType = textContentType
        
        // Set font and text color
        self.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.textColor = .black
        
        // Set placeholder styles
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor(red: 164/255, green: 164/255, blue: 164/255, alpha: 1)
        ]
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        
        // Set background color and corner radius
        self.backgroundColor = .white
        self.layer.cornerRadius = 29
        
        // Set shadow
        self.layer.shadowColor = UIColor(red: 112/255, green: 144/255, blue: 176/255, alpha: 0.2).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 16)
        self.layer.shadowRadius = 40
        self.layer.shadowOpacity = 1
        
        // Set dimensions
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 355).isActive = true
        self.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        // Padding text
        let paddingView = UIView(frame: CGRectMake(0, 0, 20, self.frame.height))
        leftView = paddingView
        leftViewMode = UITextField.ViewMode.always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Padding placeholder
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let inset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 5)
        return bounds.inset(by: inset)
    }
}
