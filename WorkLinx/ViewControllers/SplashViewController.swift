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
        
//        DataProvider.createData()
        Utils.navigate("AuthViewController", self, transitionTime: 0.8)
    }
}
