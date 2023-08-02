//
//  RegisterEmployerViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq
//

import UIKit
import SwiftUI
import FirebaseFirestore

class RegisterEmployerViewController: UIViewController {
    var texboxComopanyName: CustomTextField!
    var textBoxAddress: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add nav bar
        let navigationBar = CustomNavigationBar(title: "Create Your Workspace")
        let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        
        navigationBar.items?.first?.leftBarButtonItem = backButton
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Text fields
        texboxComopanyName = CustomTextField(placeholder: "Name", textContentType: .organizationName)
        textBoxAddress = CustomTextField(placeholder: "Address", textContentType: .fullStreetAddress)
        
        // Create the vertical stack view
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add textfields to the stack
        stackView.addArrangedSubview(texboxComopanyName)
        stackView.addArrangedSubview(textBoxAddress)
        
        view.addSubview(stackView)
        
        // Set constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
        
        
        // Create a UIButton
        let createButton = UIButton(type: .system)
        createButton.setTitle("Crerate Workspace", for: .normal)
        createButton.backgroundColor = .darkGray
        createButton.setTitleColor(.white, for: .normal)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the UIButton to the view
        view.addSubview(createButton)
        
        // Set constraints for the UIButton
        NSLayoutConstraint.activate([
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 65) // Adjust height as needed
        ])
        
        createButton.addTarget(self, action: #selector(createBttnTapped), for: .touchUpInside)
    }
    
    
    
    @objc func createBttnTapped() {
        
        // check if workspace name and address are not empty and valid
        // else show alert and return
        
        // Show UserInfoFormViewController
        
        
        // The rest of code is excuting from UserInfoFormViewController
        
        // Check if the workspace name is unique
        if isWorkspaceNameUnique(texboxComopanyName.text!) {
            // Create the workspace
            let companyName = texboxComopanyName.text!
            let companyAddress = textBoxAddress.text!
            
            // Create a serial DispatchQueue to execute tasks sequentially on the same thread
            let serialQueue = DispatchQueue(label: "SignUp Employer")
            
            // Execute the functions sequentially
            serialQueue.async {
                var workspaceId: String?
                var userDataError: Error?
                
                // Create user if not already created
                if Utils.user.id.count == 0
                {
                    // Execute createUser function
                    let createUserGroup = DispatchGroup()
                    createUserGroup.enter()
                    Utils.user.createUser(email: Utils.user.emailAddress, password: Utils.password) { result in
                        switch result {
                        case .success(let authResult):
                            // User successfully created
                            Utils.user.id = authResult.user.uid // Update the user ID with the ID from Firebase Authentication
                        case .failure(let error):
                            // Error occurred while creating the user
                            print("Error creating user: \(error.localizedDescription)")
                            return
                        }
                        createUserGroup.leave()
                    }
                    createUserGroup.wait() // Wait for the completion of createUser function
                    
                    
                }
                
                // User successfully created, now create the workspace
                let createWorkspaceGroup = DispatchGroup()
                createWorkspaceGroup.enter()
                Workspace.createWorkspace(name: companyName, address: companyAddress) { result in
                    switch result {
                    case .success(let id):
                        workspaceId = id
                    case .failure(let error):
                        // Error occurred while creating the workspace
                        print("Error creating workspace: \(error.localizedDescription)")
                    }
                    createWorkspaceGroup.leave()
                }
                createWorkspaceGroup.wait() // Wait for the completion of createWorkspace function
                
                
                // Check if workspace creation was successful
                if let workspaceId = workspaceId {
                    
                    // Create userData if not already created
                    if Utils.user.id.count != 0
                    {
                        // Workspace successfully created, now create user data
                        let createUserDataGroup = DispatchGroup()
                        createUserDataGroup.enter()
                        
                        Utils.user.defaultWorkspaceId = workspaceId
                        Utils.user.workSpaces.append(workspaceId)
                        
                        Utils.user.setUserData() { userDataResult in
                            switch userDataResult {
                            case .success:
                                createUserDataGroup.leave()
                            case .failure(let error):
                                // Error occurred while saving user data
                                print("Error saving user data: \(error.localizedDescription)")
                                userDataError = error
                                createUserDataGroup.leave()
                            }
                        }
                        createUserDataGroup.wait() // Wait for the completion of createUserData function
                        
                        // Check if there was an error while creating user data
                        if userDataError != nil {
                            // Handle the user data creation failure
                            // Show an alert or perform any other necessary action
                            print("User data creation failed.")
                            return
                        }
                    } else {
                        
                        // Creating aditional workspace
                        Utils.user.workSpaces.append(workspaceId)
                        
                        Utils.user.setUserData { result in
                            switch result {
                            case .success:
                                print("Workspace added successfully!")
                                
                                // Set new workspace and navigate to dashboard
                                Workspace.getWorkspaceByID(workspaceID: workspaceId) { workspace in
                                    if let workspace = workspace {
                                        Utils.workspace = workspace
                                        Utils.user.defaultWorkspaceId = workspaceId
                                        Utils.isAdmin = true
                                        // Navigate to the DashboardView inside the completion block
                                        Utils.navigate("DashboardView", self)
                                    } else {
                                        // Failed to fetch the workspace or some data is missing
                                        // Handle the error or show an appropriate alert
                                        print ("error")
                                    }
                                }
                            case .failure(let error):
                                print("Error adding workspace: \(error)")
                            }
                        }
                    }
                    
                    // Add the initial admin
                    let addInitialAdminGroup = DispatchGroup()
                    addInitialAdminGroup.enter()
                    Utils.workspace = Workspace(workspaceId: workspaceId, name: companyName, address: companyAddress, admins: [])
                    Utils.workspace.addInitialAdminAndEmployee(userId: Utils.user.id) { adminResult in
                        switch adminResult {
                            
                        case .success:
                            print("Initial admin and employee added successfully.")
                            
                            // All tasks completed, navigate to the dashboard view
                            // isAdmin is initially true in MenuBarViewController
                            Utils.navigate("DashboardView", self)
                        case .failure(let error):
                            print("Error adding initial admin: \(error.localizedDescription)")
                            // Handle the error appropriately.
                        }
                    }
                    
                    addInitialAdminGroup.wait() // Wait for the completion of addInitialAdmin function
                } else {
                    // Handle the workspace creation failure
                    // Show an alert or perform any other necessary action
                    print("Workspace creation failed.")
                }
            }
        } else {
            // Show alert for non-unique workspace name
            showNonUniqueNameAlert()
        }
    }
    
    func isWorkspaceNameUnique(_ name: String) -> Bool {
        // Check if there is any workspace with the same name
        return true
    }
    
    func showEmptyFieldsAlert() {
        let alertController = UIAlertController(title: "Empty Fields",
                                                message: "Please enter a name and address for the workspace.",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showNonUniqueNameAlert() {
        let alertController = UIAlertController(title: "Workspace Name must be unique",
                                                message: "A workspace with the same name already exists. Please enter a unique name.",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
}
