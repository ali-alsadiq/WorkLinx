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
        
        // Wait for 1.5 seconds before moving to the AuthViewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let authView = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
            authView.modalPresentationStyle = .fullScreen
            
            // Customize the transition animation
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .fade
            transition.subtype = .fromBottom
            self.view.window?.layer.add(transition, forKey: kCATransition)
            
            self.present(authView, animated: false, completion: nil)
        }
    }
}
