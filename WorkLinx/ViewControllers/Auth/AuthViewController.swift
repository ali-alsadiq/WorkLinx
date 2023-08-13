//
//  AuthViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-06-27.
//

import UIKit
import GoogleSignIn
import Firebase

class AuthViewController: UIViewController {
    private var signInButton: UIButton!
    private var signUpButton: UIButton!
    private var buttonStackView: UIStackView!
    private var formStackView: UIStackView!
    
    static var userSignedIn = false
    
    private var signInForm: SignInForm!
    private var signUpForm: SignUpForm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Create Google Sign-In button
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.style = .wide //
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        googleSignInButton.addTarget(self, action: #selector(googleSignInButtonTapped), for: .touchUpInside)

        
        // Add the Google Sign-In button to the button stack view
        view.addSubview(googleSignInButton)
        
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
            formStackView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20.0),
            
            googleSignInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func googleSignInButtonTapped() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if let error = error {
                print("Google Sign-In Error: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else {
                print("Google Sign-In Error: No user data found")
                return
            }

            if let email = user.profile?.email,
               let firstName = user.profile?.givenName,
               let lastName = user.profile?.familyName {
                
                Utils.user = User(id: "", emailAddress: email, defaultWorkspaceId: "")
                
                Utils.user.firstName = firstName
                Utils.user.lastName = lastName
            } else {
                print("User Data Incomplete")
            }

            guard let user = result?.user,
                let idToken = user.idToken?.tokenString
              else {
                // ... What error could be printed here???
                return
              }

              let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                             accessToken: user.accessToken.tokenString)

            if let userId = user.userID {
                print("User ID: \(userId)")
            }
            
            signInWithCredential(credential: credential)
        }
    }
    
    func signInWithCredential(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                // Error occurred while creating the user
                print(error.localizedDescription)
                return
            } else if let authResult = authResult {
                Utils.user.id = authResult.user.uid
                AuthViewController.userSignedIn = true
                
                User.fetchUserByID(userID: authResult.user.uid) { user in
                    if let user = user {
                        // User data was found - Set Data and Sign In
                        let userDataCollection = Utils.db.collection("usersData")
                        
                        userDataCollection.whereField("id", isEqualTo: Utils.user.id).getDocuments { (snapshot, error) in
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
                                }
                            }
                            
                            Workspace.getWorkspaceByID(workspaceID: Utils.user.defaultWorkspaceId) { workspace in
                                if let workspace = workspace {
                                    Utils.workspace = workspace
                                    Utils.isAdmin = workspace.admins.contains(Utils.user.id)
                                    // Navigate to the DashboardView inside the completion block
                                    
                                    Workspace.updateInvitingWorkspaces {
                                        Utils.navigate(ConfirmInvitingWorkspacesViewController(), self)
                                    }
                                    
                                } else {
                                    print ("error")
                                    return
                                }
                            }
                        }
                        
                    } else {
                        Utils.navigate("RegisterView", self)
                    }
                }
            }
        }
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
    
    func showInvalidPasswordAlert() {
        let alertController = UIAlertController(title: "Invalid Password",
                                                message: "Password must be at least 6 characters long.",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        // Present the alert
        // Make sure to have a reference to the current view controller and use it to present the alert
        present(alertController, animated: true, completion: nil)
    }
}
