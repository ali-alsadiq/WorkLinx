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
    private var signInForm: SignInForm!
    
    
    
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
    
    init(viewController: AuthViewController, signInform: SignInForm) {
        self.viewController = viewController
        self.signInForm = signInform
    }
    
    
    
    @objc private func continueButtonTapped() {
        let userExists = DataProvider.users.contains { user in
            return user.emailAddress.lowercased() == emailTextField.text?.lowercased()
        }
        
        if userExists{
            showEmailAlreadyExistsAlert()
        }
        else if passwordTextField.text?.lowercased() == confirmPasswordTextField.text?.lowercased() {
            Utils.user = User(emailAddress: emailTextField.text!.lowercased(),
                              password: passwordTextField.text!)
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RegisterView")
            
            Utils.navigate(vc, viewController)

        } else {
            showPasswordMismatchAlert()
        }
    }
    
    func showPasswordMismatchAlert() {
        let alertController = UIAlertController(title: "Password Mismatch",
                                                message: "The passwords you entered do not match. Please try again.",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        // Present the alert
        viewController?.present(alertController, animated: true, completion: nil)
    }

    
    func showEmailAlreadyExistsAlert() {
        let alertController = UIAlertController(title: "Email Already Exists",
                                                message: "The email you entered already exists. Do you want to sign in?",
                                                preferredStyle: .alert)
        
        let signInAction = UIAlertAction(title: "Sign In", style: .default) { (_) in
            // Handle Sign In button action
            self.hide()
            self.signInForm.show()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            // Handle Cancel button action
            print("Cancel button tapped")
        }
        
        alertController.addAction(signInAction)
        alertController.addAction(cancelAction)
        
        // Present the alert
        // Make sure to have a reference to the current view controller and use it to present the alert
        viewController?.present(alertController, animated: true, completion: nil)
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
