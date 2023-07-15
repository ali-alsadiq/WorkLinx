//
//  AuthViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-06-27.
//

import UIKit

class AuthViewController: UIViewController {
    private var signInButton: UIButton!
    private var signUpButton: UIButton!
    private var buttonStackView: UIStackView!
    private var formStackView: UIStackView!
    
    private var signInForm: SignInForm!
    private var signUpForm: SignUpForm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoImageView = UIImageView(image: UIImage(named: "LogoBlack"))
        logoImageView.contentMode = .scaleAspectFit
        
        // Set the frame for the logo image view
        let logoWidth: CGFloat = 100.0
        let logoHeight: CGFloat = 40.0
        let logoFrame = CGRect(x: 0, y: 0, width: logoWidth, height: logoHeight)
        logoImageView.frame = logoFrame
        
        // Create a container view to hold the logo image view
        let logoContainerView = UIView(frame: logoFrame)
        logoContainerView.addSubview(logoImageView)
        
        // Set the container view as the title view of the navigation bar
        navigationItem.titleView = logoContainerView
        
        // Create Sign In and Sign Up Buttons
        signInButton = createButton(title: "Sign In", action: #selector(buttonTapped(_:)))
        signUpButton = createButton(title: "Sign Up", action: #selector(buttonTapped(_:)))
        
        // Set Sign in to active, and sign Up to inactive
        setActiveButton(signInButton)
        setInactiveButton(signUpButton)
        
        // Add buttons to a stack view
        buttonStackView = UIStackView(arrangedSubviews: [signInButton, signUpButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20.0
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create Auth forms
        signInForm = SignInForm(viewController: self)
        signUpForm = SignUpForm(viewController: self, signInform: signInForm)
        
        formStackView = UIStackView(arrangedSubviews: [signInForm.view, signUpForm.view])
        formStackView.axis = .vertical
        formStackView.spacing = 20.0
        formStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonStackView)
        view.addSubview(formStackView)
        
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200.0),
            
            formStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            formStackView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20.0)
        ])
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if let signInButton = signInButton, let signUpButton = signUpButton {
            setActiveButton(sender)
            
            if sender == signInButton && signInForm.view.isHidden {
                setInactiveButton(signUpButton)
                signInForm.show()
                signUpForm.hide()
            } else if sender == signUpButton && signUpForm.view.isHidden{
                setInactiveButton(signInButton)
                signInForm.hide()
                signUpForm.show()
            }
        }
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        return button
    }
    
    private func setActiveButton(_ button: UIButton) {
        button.alpha = 1.0
        
        let underlineView = UIView()
        underlineView.backgroundColor = .black
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            underlineView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            underlineView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            underlineView.widthAnchor.constraint(equalTo: button.widthAnchor, constant: 10),
            underlineView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setInactiveButton(_ button: UIButton) {
        button.alpha = 0.5
        
        // Remove the underline view from the inactive button
        button.subviews.forEach { subview in
            if subview.backgroundColor == .black {
                subview.removeFromSuperview()
            }
        }
    }
}
