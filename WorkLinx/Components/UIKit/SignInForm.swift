//
//  SignInForm.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-06-27.
//

import UIKit
import Firebase

class SignInForm {
    public var emailTextField: CustomTextField!
    private var passwordTextField: CustomTextField!
    private var signInButton: CustomButton!
    private var viewController: AuthViewController!
    
    var view: UIView {
        return stackView
    }
    
    
    init(viewController: AuthViewController) {
        self.viewController = viewController
    }
    
    private lazy var stackView: UIStackView = {
        emailTextField = CustomTextField(placeholder: "Email", textContentType: .emailAddress)
        emailTextField.autocapitalizationType = .none
        
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
        let email = emailTextField.text!.lowercased()
        let password = passwordTextField.text!
        
        // Check if the email field is empty
        if !emailTextField.hasText {
            showEmptyEmailAlert()
            return
        }
        
        // Check if the password field is empty
        if !passwordTextField.hasText {
            showEmptyPasswordAlert()
            return
        }
        
        // Check if the password is invalid
        if passwordTextField.text!.isEmpty || passwordTextField.text!.count < 6 {
            viewController.showInvalidPasswordAlert()
            return
        }
        
        if !Utils.isValidEmail(emailTextField.text!) {
            Utils.showAlert(title: "Invalid Email", message: "Please enter a valid email address.", viewController: viewController)
            return
        }
        
        signInUser(email: email, password: password) { result in
            switch result {
            case .success(let authResult):
                // User sign-in successful
                let user = authResult.user
                print("User signed in: \(user.uid)")
                
                let db = Firestore.firestore()
                let userDataCollection = db.collection("usersData")
                
                userDataCollection.whereField("emailAddress", isEqualTo: user.email!).getDocuments { (snapshot, error) in
                    if let error = error {
                        // Error occurred while querying the database
                        print("Error querying database: \(error.localizedDescription)")
                        return
                    }
                    
                    if let snapshot = snapshot {
                        if let userData = snapshot.documents.first?.data() {
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: userData)
                                let decoder = JSONDecoder()
                                let user = try decoder.decode(User.self, from: jsonData)
                                
                                // Set the decoded user to Utils.user
                                Utils.user = user
                                
                            } catch {
                                print("Error decoding user data: \(error)")
                            }
                        } else {
                            // User doesn't exist in the database
                            self.showNoAccountFoundAlert()
                        }
                    }
                    
                    Workspace.getWorkspaceByID(workspaceID: Utils.user.defaultWorkspaceId) { workspace in
                        if let workspace = workspace {
                            Utils.workspace = workspace
                            Utils.isAdmin = workspace.admins.contains(Utils.user.id)
                            
                            Workspace.updateInvitingWorkspaces {
                                Utils.navigate(ConfirmInvitingWorkspacesViewController(), self.viewController)
                            }
                            
                        } else {
                            // Failed to fetch the workspace or some data is missing
                            // Handle the error or show an appropriate alert
                            print ("error")
                        }
                    }
                }
            case .failure(let error):
                // User sign-in failed
                if let authError = error as NSError? {
                    switch(authError)
                    {
                    case AuthErrorCode.userNotFound :
                        self.showNoAccountFoundAlert()
                    case AuthErrorCode.wrongPassword:
                        self.showWrongPasswordAlert()
                    default:
                        self.showSignInErrorAlert()
                    }
                }
            }
        }
    }
    
    func showSignInErrorAlert() {
        let alertController = UIAlertController(
            title: "Error",
            message: "An error occurred while signing in. Please try again later.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func showNoAccountFoundAlert() {
        let alertController = UIAlertController(
            title: "No Account Found",
            message: "There is no account with the given email address. Do you want to sign up?",
            preferredStyle: .alert
        )
        
        let signUpAction = UIAlertAction(title: "Sign Up", style: .default) { (_) in
            // Handle Sign Up button action
            // Create user
            Utils.user = User(id: "", emailAddress: self.emailTextField.text!.lowercased(), defaultWorkspaceId: "")
            Utils.password = self.passwordTextField.text!
            Utils.navigate("RegisterView", self.viewController)
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
    
    func signInUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                // Error occurred while signing in the user
                completion(.failure(error))
            } else if let authResult = authResult {
                // User successfully signed in
                completion(.success(authResult))
            }
        }
    }
}
