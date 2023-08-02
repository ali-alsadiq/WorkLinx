//
//  ConfirmInvitingWorkspacesViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-02.
//

import UIKit
import SwiftUI

class ConfirmInvitingWorkspacesViewController: UIViewController {
    
    private var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueIfEmpty()
        
        view.backgroundColor = .white

        // Create and configure the title label
        titleLabel = UILabel()
        titleLabel.text = "New Workspace Invitation\(Utils.invitingWorkspaces.count == 1 ? "" : "s")"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        
        
        // Create and configure the SwiftUI workspace list view
        let invitingWorkspaceListView = InvitingWorkspacesList(workspaces: Utils.invitingWorkspaces,
                                                               onAccept: { workspace in
            self.confirmInvitation(workspace: workspace)
        },
                                                               onReject: { workspace in
            // Handle logic when user rejects the workspace
            // You can use workspace parameter here
            print(workspace.description)
        })
        
        let hostingController = UIHostingController(rootView: invitingWorkspaceListView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    func confirmInvitation(workspace: Workspace) {
        
        if Utils.user.defaultWorkspaceId.isEmpty {
            // Assign default workspace ID to the user
            Utils.user.defaultWorkspaceId = workspace.workspaceId
            
            // Set Utils.workspace to the inviting workspace
            Utils.workspace = workspace
            
            // Register a new user
            Utils.user.createUser(email: Utils.user.emailAddress, password: Utils.password) { result in
                switch result {
                case .success(let authResult):
                    // User registered successfully
                    Utils.user.id = authResult.user.uid
                    Utils.user.workSpaces.append(workspace.workspaceId)
                    
                    // Create usersData doc
                    Utils.user.setUserData() { _ in }
                    
                    // Update workspace
                    Utils.workspace.employees.append(Workspace.Employee(employeeId: Utils.user.id, payrate: 0, position: ""))
                    Utils.workspace.invitedUsers.removeAll(where: { $0 == Utils.user.emailAddress })
                    Workspace.updateWorkspace(workspace: Utils.workspace) { _ in }
                    
                    // Remove invitingWorkspace and continue if is empty
                    Utils.invitingWorkspaces.removeAll(where: { $0.workspaceId == workspace.workspaceId })
                    self.continueIfEmpty()
                    
                case .failure(let error):
                    // Error occurred while creating the user
                    print("Error creating user: \(error.localizedDescription)")
                }
            }
        }
        else {
            // Add a workspace without changing user default workspace or registering user
            // call user.update data and workspace. update data once
            // when everything is added and continue button is clicked
        }
//        Utils.workspace.employees.append(Workspace.Employee(employeeId: Utils.user.id, payrate: 0, position: ""))
    }
    
    func continueIfEmpty() {
        if Utils.invitingWorkspaces.isEmpty {
            dismiss(animated: true) {
                let dashboardVC = DashboardViewController()
                dashboardVC.modalPresentationStyle = .fullScreen
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = dashboardVC
                    window.makeKeyAndVisible()
                }
            }
        }
    }
    
}
