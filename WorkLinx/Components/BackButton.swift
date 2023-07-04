//
//  BackButton.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-04.
//

import UIKit

class BackButton: UIBarButtonItem {
    
    convenience init(text: String?, target: UIViewController, action: Selector) {
        let symbolImage = UIImage(systemName: "chevron.left")
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .heavy)
        let resizedImage = symbolImage?.withConfiguration(symbolConfiguration).withTintColor(.black, renderingMode: .alwaysOriginal)
        
        if let buttonText = text {
            self.init(title: buttonText, style: .plain, target: target, action: action)
        } else {
            self.init(image: resizedImage, style: .plain, target: target, action: action)
        }
    }
}

