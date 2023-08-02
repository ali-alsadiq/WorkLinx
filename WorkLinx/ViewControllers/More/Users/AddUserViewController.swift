//
//  AddUserViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-02.
//

import UIKit
import SwiftUI

class AddUserViewController: UIViewController {

    private var navigationBar: CustomNavigationBar!
    private var emailTextField: CustomTextField!
    private var addButton: CustomButton!
    private let emailListManager = EmailListManager()
    private var inviteButton: BackButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Add nav bar
        navigationBar = CustomNavigationBar(title: "Add User")
        let backButton = BackButton(text: "Cancel", target: self, action: #selector(goBack))
        inviteButton = BackButton(text: "Invite", target: self, action: #selector(inviteButtonTapped))
        inviteButton.isEnabled = false
        
        navigationBar.items?.first?.leftBarButtonItem = backButton
        navigationBar.items?.first?.rightBarButtonItem = inviteButton
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        emailTextField = CustomTextField(placeholder: "Email", textContentType: .emailAddress)
        emailTextField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        addButton = CustomButton(label: "Add")
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emailTextField)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 55),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            addButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let emailListView = UIHostingController(
            rootView: EmailListView(emailListManager: emailListManager, onEmailRemoved: {
                self.inviteButton.isEnabled = !self.emailListManager.emails.isEmpty
            })
        )
        
        emailListView.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(emailListView)
        view.addSubview(emailListView.view)
        
        NSLayoutConstraint.activate([
            emailListView.view.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            emailListView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emailListView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emailListView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        emailListView.didMove(toParent: self)
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        emailListManager.emails.removeAll()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func inviteButtonTapped() {
        Utils.workspace.invitedUsers.append(contentsOf: emailListManager.emails)
        Workspace.updateWorkspace(workspace: Utils.workspace) { error in
            if let error = error {
                print("Error updating workspace: \(error.localizedDescription)")
            } else {
                print("Workspace updated successfully")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonTapped() {
        let enteredEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // Check if the user has already been invited
        if Utils.workspace.invitedUsers.contains(enteredEmail) {
            Utils.showAlert(title: "User Invited", message: "The user has already been invited.", viewController: self)
        }
        else if emailListManager.emails.contains(enteredEmail) {
            Utils.showAlert(title: "Email Already Added", message: "The email is already added to the list.", viewController: self)
        }
        else {
            // Check if the entered text is a valid email address
            if Utils.isValidEmail(enteredEmail) {
                emailListManager.addEmail(enteredEmail)
                inviteButton.isEnabled = true
            } else {
                Utils.showAlert(title: "Invalid Email", message: "Please enter a valid email address.", viewController: self)
            }
        }
    }
    
    
    
    
}
