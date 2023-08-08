//
//  UserInforFormViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-02.
//

import UIKit
import SwiftUI

class UserInfoFormViewController: UIViewController {
    
    private var navigationBar: CustomNavigationBar!
    private var backButton: UIBarButtonItem!
    
    private var scrollView: UIScrollView!
    private var firstNameTextField: CustomTextField!
    private var lastNameTextField: CustomTextField!
    private var addressTextField: CustomTextField!
    private var texboxComopanyName: CustomTextField!
    private var textBoxCompanyAddress: CustomTextField!
    
    private var completeButton: CustomButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Add nav bar
        navigationBar = CustomNavigationBar(title: "User Information")
        backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        
        navigationBar.items?.first?.leftBarButtonItem = backButton
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Set up the scroll view
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Add form
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        firstNameTextField = CustomTextField(placeholder: "First Name", textContentType: .givenName)
        lastNameTextField = CustomTextField(placeholder: "Last Name", textContentType: .familyName)
        addressTextField = CustomTextField(placeholder: "Adress", textContentType: .fullStreetAddress)
        
        scrollView.addSubview(firstNameTextField)
        scrollView.addSubview(lastNameTextField)
        scrollView.addSubview(addressTextField)
        
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstNameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            firstNameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            firstNameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 20),
            lastNameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            lastNameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            
            addressTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 20),
            addressTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            addressTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
        ])
        
        if Utils.isAdmin {
            // Workspace Text fields
            texboxComopanyName = CustomTextField(placeholder: "Workspace Name", textContentType: .organizationName)
            textBoxCompanyAddress = CustomTextField(placeholder: "Workspace Address", textContentType: .fullStreetAddress)
            
            // Add textfields to the scroll view
            scrollView.addSubview(texboxComopanyName)
            scrollView.addSubview(textBoxCompanyAddress)
            
            texboxComopanyName.translatesAutoresizingMaskIntoConstraints = false
            textBoxCompanyAddress.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                texboxComopanyName.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 20),
                texboxComopanyName.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
                texboxComopanyName.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
                
                textBoxCompanyAddress.topAnchor.constraint(equalTo: texboxComopanyName.bottomAnchor, constant: 20),
                textBoxCompanyAddress.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
                textBoxCompanyAddress.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            ])
        }
        
        
        let completeButton = CustomButton(label: "Complete")
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func completeButtonTapped() {
        // Check if first name and last name are not empty after stripping leading and trailing white space
        guard let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !firstName.isEmpty,
              let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !lastName.isEmpty else {
            // Display an alert indicating that first name and last name are required
            showAlert(title: "Incomplete Information", message: "Please enter your first name and last name.")
            return
        }
        
        // Assign user's first name, last name, and address
        Utils.user.firstName = firstName
        Utils.user.lastName = lastName
        Utils.user.address = addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if Utils.isAdmin {
            guard let companyName = texboxComopanyName.text?.trimmingCharacters(in: .whitespacesAndNewlines), !companyName.isEmpty,
                  let companyAddress = textBoxCompanyAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines), !companyAddress.isEmpty else {
                // Display an alert indicating that first name and last name are required
                showAlert(title: "Incomplete Information", message: "Please enter your workspace name and address.")
                return
            }
            
            Utils.workspace.name = companyName
            Utils.workspace.address = companyAddress
            createUserAndWorkSpace()
        }
        
        if Utils.isAdmin {
            Utils.navigate(DashboardViewController(), self)
        }
        else {
            Utils.navigate(ConfirmInvitingWorkspacesViewController(), self)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func createUserAndWorkSpace() {
        
        // Create the workspace
        let companyName = texboxComopanyName.text!
        let companyAddress = textBoxCompanyAddress.text!
        
        // Create a serial DispatchQueue to execute tasks sequentially on the same thread
        let serialQueue = DispatchQueue(label: "SignUp Employer")
        
        // Execute the functions sequentially
        serialQueue.async {
            var workspaceId: String?
            var userDataError: Error?
            
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
            
            // User successfully created, now create the workspace
            let createWorkspaceGroup = DispatchGroup()
            createWorkspaceGroup.enter()
            let newWorkspace =  Workspace(workspaceId: "",
                                          name: companyName,
                                          address: companyAddress,
                                          admins: [Utils.user.id],
                                          employees: [Workspace.Employee(employeeId: Utils.user.id, payrate: 0, position: "")])
            Workspace.createWorkspace(workspace: newWorkspace) { result in
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
            }
        }
    }
}

