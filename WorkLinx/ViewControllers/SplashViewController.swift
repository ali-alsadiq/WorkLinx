//
//  ViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-06-27.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DataProvider.createData()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authView = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
        Utils.navigate(authView, self, transitionTime: 0.8)
        
    }
}
