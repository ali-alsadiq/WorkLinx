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
        
//        clearForm()
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
