//
//  RegisterViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-06-27.
//

import UIKit
import Firebase
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var employeeBttn: UIButton!
    @IBOutlet weak var employerBttn: UIButton!

    
    @IBAction func employeeBttnTapped() {
        Utils.isAdmin = false
        isInvited { invited in
            guard invited else {
                // Employee doesn't have any invitations
                self.showNoWorkInvitationAlert()
                return
            }
            
            // Employee has invitations
            Utils.navigate(UserInfoFormViewController(), self)
        }
    }
    
    @IBAction func employerBttnTapped() {
        Utils.isAdmin = true
        Utils.navigate(UserInfoFormViewController(), self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add nav bar with back button
        let navigationBar = CustomNavigationBar(title: "Register")
        let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        
        navigationBar.items?.first?.leftBarButtonItem = backButton
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Add text and styles for buttons
        let employeeAttributedText = NSMutableAttributedString(string: "I'm an employee\n\nI want to join my time and get my schedule.")
        employeeAttributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], range: NSRange(location: 0, length: 15))
        
        employeeBttn.setAttributedTitle(employeeAttributedText, for: .normal)
        employeeBttn.titleLabel?.numberOfLines = 0

        
        let employerAttributedText = NSMutableAttributedString(string: "I’m setting up my business\n\nI want to create a workplace, set a schedule and invite employees.")
        employerAttributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], range: NSRange(location: 0, length: 26))
        
        employerBttn.setAttributedTitle(employerAttributedText, for: .normal)
        employerBttn.titleLabel?.numberOfLines = 0

    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    func isInvited(completion: @escaping (Bool) -> Void) {
        Workspace.updateInvitingWorkspaces() {
            if !Utils.invitingWorkspaces.isEmpty {
                // User is invited to at least one workspace
                completion(true)
            } else {
                // User is not invited to any workspace
                completion(false)
            }
        }
    }
    
    func showNoWorkInvitationAlert() {
        let title = "No Work Invitation"
        let message = "You don't have any work invitations. Please contact your workspace admin to receive an invitation, or create a workspace to continue."
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let createWorkspaceAction = UIAlertAction(title: "Create Workspace", style: .default) { (_) in
            self.employerBttnTapped()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in}
        
        alertController.addAction(createWorkspaceAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
