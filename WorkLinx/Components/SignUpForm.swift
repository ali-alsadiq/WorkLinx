//
//  SignUpForm.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-06-27.
//

import UIKit
import FirebaseFirestore

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
        emailTextField.autocapitalizationType = .none

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
        // Check if the email already exists in the "users" collection in Firestore
        let email = emailTextField.text!.lowercased()
        let usersCollection = Firestore.firestore().collection("usersData")
        
        if !Utils.isValidEmail(emailTextField.text!) {
            Utils.showAlert(title: "Invalid Email", message: "Please enter a valid email address.", viewController: viewController)
            return
        }
        
        // Check if the password is invalid
        if passwordTextField.text!.isEmpty || passwordTextField.text!.count < 6 {
            viewController.showInvalidPasswordAlert()
            return
        }
        else {
            usersCollection.whereField("emailAddress", isEqualTo: email).getDocuments { (snapshot, error) in
                if let error = error {
                    // Error occurred while querying the database
                    print("Error querying database: \(error.localizedDescription)")
                    return
                }
                
                if self.passwordTextField.text?.lowercased() != self.confirmPasswordTextField.text?.lowercased() {
                    self.showPasswordMismatchAlert()
                    return
                }
                
                if let snapshot = snapshot {
                    if snapshot.documents.isEmpty {
                        Utils.user = User(id: "", emailAddress: email, defaultWorkspaceId: "")
                        Utils.password = self.passwordTextField.text!
                        Utils.navigate("RegisterView", self.viewController)
                    } else {
                        // User with the provided email already exists
                        print("User with the provided email already exists.")
                        self.showEmailAlreadyExistsAlert()
                    }
                }
            }
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
            // Fill up the email address text field with the existing email
            self.signInForm.show()
            self.signInForm.emailTextField.text = self.emailTextField.text
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
