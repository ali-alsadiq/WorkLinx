//
//  FullScreenImageViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-11.
//

import Foundation
import UIKit

class FullScreenImageViewController: UIViewController {
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -40).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, constant: -40).isActive = true
        
        
        imageView.contentMode = .scaleAspectFit
    }
}
