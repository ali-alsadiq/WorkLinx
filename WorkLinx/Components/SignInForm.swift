//
//  SignInForm.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-06-27.
//

import UIKit

class SignInForm {
    private var emailTextField: CustomTextField!
    private var passwordTextField: CustomTextField!
    private var signInButton: CustomButton!
    
    var view: UIView {
        return stackView
    }
    
    private let viewController: UIViewController
    
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    private lazy var stackView: UIStackView = {
        emailTextField = CustomTextField(placeholder: "Email", textContentType: .emailAddress)
        passwordTextField = CustomTextField(placeholder: "Password", textContentType: .password)
        
        passwordTextField.isSecureTextEntry = true
        
        signInButton = CustomButton(label: "Sign In")
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signInButton])
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    @objc private func signInButtonTapped() {
        print("Email: \(emailTextField.text ?? "")")
        print("Password: \(passwordTextField.text ?? "")")
        
        let userExists = DataProvider.users.contains { user in
            return user.emailAddress.lowercased() == emailTextField.text?.lowercased()
        }
        
        let validPassword = DataProvider.users.contains { user in
            return user.emailAddress.lowercased() == emailTextField.text?.lowercased()
                   && user.password == passwordTextField.text
        }
        
        if !emailTextField.hasText {
            showEmptyEmailAlert()
        } else if !passwordTextField.hasText {
            showEmptyPasswordAlert()
        } else if !userExists {
            noAccountFound()
        } else if userExists && !validPassword {
            showWrongPasswordAlert()
        } else if let currentUser = DataProvider.users.first(where: { user in
            return user.emailAddress.lowercased() == emailTextField.text?.lowercased()
                   && user.password == passwordTextField.text}) {
            
            // User with valid email and password found
            Utils.user = currentUser
            
            // Go to Dashboard View
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DashboardView")
            
            Utils.navigate(vc, viewController)
        }
    }
    
    func noAccountFound() {
        let alertController = UIAlertController(
            title: "No Account Found",
            message: "There is no account with the given email address. Do you want to sign up?",
            preferredStyle: .alert
        )
        
        let signUpAction = UIAlertAction(title: "Sign Up", style: .default) { (_) in
            // Handle Sign Up button action
            print("Sign Up button tapped")
            // Perform sign up logic here
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            // Handle Cancel button action
            print("Cancel button tapped")
        }
        
        alertController.addAction(signUpAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func showEmptyEmailAlert() {
        let alertController = UIAlertController(title: "Empty Email", message: "Please enter your email.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func showEmptyPasswordAlert() {
        let alertController = UIAlertController(title: "Empty Password", message: "Please enter your password.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func showWrongPasswordAlert() {
        let alertController = UIAlertController(
            title: "Wrong Password",
            message: "The password you entered is incorrect. Do you want to reset your password?",
            preferredStyle: .alert
        )
        
        let forgotPasswordAction = UIAlertAction(title: "Forgot Password?", style: .default) { (_) in
            self.handleForgotPasswordAction()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(forgotPasswordAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func handleForgotPasswordAction() {
        print("Forgot Password button tapped")
        // Perform forgot password logic here
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
    }
}
