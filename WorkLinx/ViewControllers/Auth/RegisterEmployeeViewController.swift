//
//  RegisterEmployeeViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq
//

import UIKit
import Firebase
import SwiftUI

// This just checks if employee is invited and rediret to other views
class RegisterEmployeeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        isInvited { invited in
            guard invited else {
                // Employee doesn't have any invitations
                self.showNoWorkInvitationAlert()
                return
            }
            
            // Employee has invitations
            self.showUserInfoForm()
        }
    }

    func isInvited(completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("workspaces").whereField("invitedUsers", arrayContains: Utils.user.emailAddress).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                completion(false)
            } else {
                if let documents = querySnapshot?.documents {
                    Utils.invitingWorkspaces = documents.compactMap { document in
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                            let workspace = try JSONDecoder().decode(Workspace.self, from: jsonData)
                            print(workspace.description)
                            return workspace
                        } catch {
                            print("Error decoding workspace data: \(error)")
                            return nil
                        }
                    }
                    
                    if !Utils.invitingWorkspaces.isEmpty {
                        // User is invited to at least one workspace
                        completion(true)
                    } else {
                        // User is not invited to any workspace
                        completion(false)
                    }
                } else {
                    // No documents found
                    completion(false)
                }
            }
        }
    }
    
    func showNoWorkInvitationAlert() {
        let title = "No Work Invitation"
        let message = "You don't have any work invitations. Please contact your workspace admin to receive an invitation, or create a workspace to continue."
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let createWorkspaceAction = UIAlertAction(title: "Create Workspace", style: .default) { (_) in
            Utils.navigate("RegisterEmployerView", self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(createWorkspaceAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    
    func showUserInfoForm() {
        // Register user in DB
        let userInfoFormView = UserInfoFormViewController()
        userInfoFormView.modalPresentationStyle = .fullScreen

        present(userInfoFormView, animated: true, completion: nil)
    }
}
