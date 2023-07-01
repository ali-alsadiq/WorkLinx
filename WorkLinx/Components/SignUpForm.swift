//
//  SignUpForm.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-06-27.
//

import UIKit

class SignUpForm {
    private var emailTextField: CustomTextField!
    private var passwordTextField: CustomTextField!
    private var confirmPasswordTextField: CustomTextField!
    private var continueButton: CustomButton!
    
    private var viewController: AuthViewController!
    
    
    
    var view: UIView {
        return stackView
    }
    
    private lazy var stackView: UIStackView = {
        emailTextField = CustomTextField(placeholder: "Email", textContentType: .emailAddress)
        passwordTextField = CustomTextField(placeholder: "Password", textContentType: .newPassword)
        confirmPasswordTextField = CustomTextField(placeholder: "Confirm Password", textContentType: .newPassword)
        
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        continueButton = CustomButton(label: "Continue")
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, confirmPasswordTextField, continueButton])
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.isHidden = true
        
        return stackView
    }()
    
    init(viewController: AuthViewController) {
        self.viewController = viewController
    }
    
    @objc private func continueButtonTapped() {
        // continue if email is unique and password match
        if passwordTextField.text == confirmPasswordTextField.text {
            print("Email: \(emailTextField.text ?? "")")
            print("Password: \(passwordTextField.text ?? "")")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let registerViewController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else {
                fatalError("Unable to instantiate RegisterViewController from storyboard")
            }
            registerViewController.modalPresentationStyle = .fullScreen

            // Pass data to RegisterViewController
            registerViewController.emailAddress = emailTextField.text!
            registerViewController.password = passwordTextField.text!

            // Customize the transition animation
            let transition = CATransition()
            transition.duration = 0.2
            transition.type = .fade
            transition.subtype = .fromBottom
            viewController.view.window?.layer.add(transition, forKey: kCATransition)

            viewController.present(registerViewController, animated: false, completion: nil)

        } else {
            print("Password not matching")
        }
    }
    
    
    func show() {
        stackView.isHidden = false
        clearForm()
    }
    
    func hide() {
        stackView.isHidden = true
    }
    
    private func clearForm() {
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
}
