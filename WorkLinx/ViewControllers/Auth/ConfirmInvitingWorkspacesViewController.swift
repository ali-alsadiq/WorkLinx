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
    private var isUserAddingMultipleWorkspaces = false
    private var confirmLaterButton: CustomButton!
    private var isLoggedIn = false
    
    private var navigationBar: CustomNavigationBar!
    private var backButton: BackButton!
    
    static var isConfirmingInvitationLater = false
    
    @ObservedObject private var workspaceManager = WorkspaceManager()
    
    
    
    init(isLoggedIn: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.isLoggedIn = isLoggedIn
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueIfEmpty()
        
        view.backgroundColor = .white
        
        // Add nav bar
        navigationBar = CustomNavigationBar(title: "Workspace Invitation\(Utils.invitingWorkspaces.count == 1 ? "" : "s")")
        backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        
        if isLoggedIn {
            navigationBar.items?.first?.leftBarButtonItem = backButton
        }

        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        // Create and configure the SwiftUI workspace list view
        let invitingWorkspaceListView = InvitingWorkspacesList(workspaceManager: workspaceManager,
                                                               onAccept: { workspace in
            self.confirmInvitation(workspace: workspace)
        },
                                                               onReject: { workspace in
            self.rejectInvitation(workspace: workspace)
            
        })
        
        let hostingController = UIHostingController(rootView: invitingWorkspaceListView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 20),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
        
        // Create and configure the "Confirm Later" button
        confirmLaterButton = CustomButton(label: "Confirm Later")
        confirmLaterButton.addTarget(self, action: #selector(confirmLaterButtonTapped), for: .touchUpInside)
        confirmLaterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmLaterButton)
        
        NSLayoutConstraint.activate([
            confirmLaterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmLaterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            confirmLaterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
        
        // Hide the button initially if user's default workspace is empty
        confirmLaterButton.isHidden = Utils.user.defaultWorkspaceId.isEmpty
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    func confirmInvitation(workspace: Workspace) {
        
        if Utils.user.defaultWorkspaceId.isEmpty {
            // Assign default workspace ID to the user
            Utils.user.defaultWorkspaceId = workspace.workspaceId
            confirmLaterButton.isHidden = Utils.user.defaultWorkspaceId.isEmpty
            
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
                    
                    self.workspaceManager.removeWorkspace(workspace)
                    self.continueIfEmpty()
                    
                case .failure(let error):
                    // Error occurred while creating the user
                    print("Error creating user: \(error.localizedDescription)")
                }
            }
        }
        else {
            Utils.user.workSpaces.append(workspace.workspaceId)
            
            // Update workspace
            workspace.employees.append(Workspace.Employee(employeeId: Utils.user.id, payrate: 0, position: ""))
            workspace.invitedUsers.removeAll(where: { $0 == Utils.user.emailAddress })
            Workspace.updateWorkspace(workspace: workspace) { _ in }
            
            self.workspaceManager.removeWorkspace(workspace)
            self.continueIfEmpty()
        }
    }
    
    func rejectInvitation(workspace: Workspace) {
        Utils.invitingWorkspaces.removeAll(where: { $0.workspaceId == workspace.workspaceId })
        workspace.invitedUsers.removeAll(where: { $0 == Utils.user.emailAddress })
        Workspace.updateWorkspace(workspace: workspace) { _ in }
        workspaceManager.removeWorkspace(workspace)
        continueIfEmpty()
    }
    
    func continueIfEmpty() {
        if isUserAddingMultipleWorkspaces {
            // Update usersData doc
            Utils.user.setUserData() { _ in }
        }
        
        if Utils.invitingWorkspaces.isEmpty {
            isLoggedIn ? goBack() : Utils.navigate(DashboardViewController(), self)
        }
    }
    
    @objc func confirmLaterButtonTapped() {
        ConfirmInvitingWorkspacesViewController.isConfirmingInvitationLater = true
        isLoggedIn ? goBack() : Utils.navigate(DashboardViewController(), self)
    }
}
