//
//  CustomNavigationBar.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-04.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    init(title: String) {
        super.init(frame: .zero)
        
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        
        let navigationItem = UINavigationItem(title: title)
        titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]

        items = [navigationItem]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

