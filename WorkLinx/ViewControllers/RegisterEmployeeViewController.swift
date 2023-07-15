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
        for workspace in DataProvider.workSpaces {
            for user in workspace.employees {
                if user.emailAddress.lowercased() == Utils.user.emailAddress.lowercased() {
                    Utils.user.defaltWorkspace = workspace
                    print("\(workspace.name)")
                    return true
                }
                
            }
        }
        return false
    }
    
    
    func showNoWorkInvitationAlert() {
        let title = "No Work Invitation"
        let message = "You don't have any work invitations. Please create a workspace or contact your workspace admin to receive an invitation."
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let createWorkspaceAction = UIAlertAction(title: "Create Workspace", style: .default) { (_) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RegisterEmployerView")
            
            Utils.navigate(vc, self)
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardView")
        
        Utils.navigate(vc, self)
    }
}
