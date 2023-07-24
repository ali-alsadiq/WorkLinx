import UIKit

class RegisterEmployeeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isInvited() {
            // Employee has invitations
            showDashboardView()
        } else {
            // Employee doesn't have any invitations
            showNoWorkInvitationAlert()
        }
    }
    
    func isInvited() -> Bool {
//        for workspace in DataProvider.workSpaces {
//            for user in workspace.employees {
//                if user.emailAddress.lowercased() == Utils.user.emailAddress.lowercased() {
//                    Utils.user.defaultWorkspace = workspace
//                    return true
//                }
//            }
//        }
//        return false
        true
    }
    
    
    func showNoWorkInvitationAlert() {
        let title = "No Work Invitation"
        let message = "You don't have any work invitations. Please create a workspace or contact your workspace admin to receive an invitation."
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let createWorkspaceAction = UIAlertAction(title: "Create Workspace", style: .default) { (_) in
            Utils.navigate("RegisterEmployerView", self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.showDashboardView()
        }
        
        alertController.addAction(createWorkspaceAction)
        alertController.addAction(cancelAction)
        
        let alertControllerContainer = alertController.view.subviews.first?.subviews.first?.subviews.first
        alertControllerContainer?.backgroundColor = .white
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showDashboardView() {
        // Register user in DB
        RegisterViewController.registerUser(email: Utils.user.emailAddress.lowercased(), password: Utils.password) { result in
            switch result {
            case .success(let authResult):
                // User creation successful
                let user = authResult.user
                print("User created: \(user.uid)")
                
                // Perform any other actions after user registration
            case .failure(let error):
                // User creation failed
                print("Error creating user: \(error.localizedDescription)")
                
                // Display an error message to the user or handle the error appropriately
            }
        }
        
        Utils.navigate("DashboardView", self)
    }
}
