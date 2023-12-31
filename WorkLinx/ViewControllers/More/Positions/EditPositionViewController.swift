//
//  EditPositionViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-01.
//

import UIKit

class EditPositionViewController: UIViewController {
    
    public var currentPosition: String
    public var role: String
    private var initialRole: String!
    private var positionsTableView: PositionsViewController
    private var navigationBar: CustomNavigationBar!
    private var editButton: UIBarButtonItem!
    public var saveButton: UIBarButtonItem!
    private var cancelButton: UIBarButtonItem!
    private var backButton: UIBarButtonItem!
    private var positionTextField: CustomTextField!
    private var adminButton: UIButton!
    private var userButton: UIButton!
        
    private var assignButton: UIButton!
    private var deleteButton: UIButton!
    private var editButtonsStack: UIStackView!
    
    private var userIds: [String]!
    
    
    init(currentPosition: String, role: String, positionsTableView: PositionsViewController) {
        self.currentPosition = currentPosition
        self.role = role
        self.positionsTableView = positionsTableView
        self.initialRole = role
       
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // Filter employees to get only those whose positions match the current position
        let filteredEmployees = Utils.workspace.employees.filter { $0.position == currentPosition }
        
        // Extract user IDs from the filtered employees
        userIds = filteredEmployees.map { $0.employeeId }
        
        if userIds.count > 0 {
            // Fetch users by IDs
            User.fetchUsersByIDs(userIDs: userIds) { fetchedUsers in
                // Assign fetched users to AddPositionViewController.assignedUsers
                AddPositionViewController.assignedUsers = fetchedUsers
            }
        }
        
        // Add nav bar
        navigationBar = CustomNavigationBar(title: "Position")
        backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        
        cancelButton = UIBarButtonItem()
        cancelButton.title = "Cancel"
        cancelButton.target = self
        cancelButton.action = #selector(cancelButtonTapped)
        cancelButton.isEnabled = true
        
        editButton = UIBarButtonItem()
        editButton.title = "Edit"
        editButton.target = self
        editButton.action = #selector(editButtonTapped)
        editButton.isEnabled = true
        
        saveButton = UIBarButtonItem()
        saveButton.title = "Save"
        saveButton.target = self
        saveButton.action = #selector(saveButtonTapped)
        saveButton.isEnabled = false
        
        navigationBar.items?.first?.leftBarButtonItem = backButton
        navigationBar.items?.first?.rightBarButtonItem = editButton
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        // Add form to add position
        positionTextField = CustomTextField(placeholder: "Position", textContentType: .jobTitle)
        positionTextField.translatesAutoresizingMaskIntoConstraints = false
        positionTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        positionTextField.isEnabled = false
        positionTextField.text = currentPosition
        positionTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        
        view.addSubview(positionTextField)
        
        adminButton = UIButton(type: .system)
        adminButton.setTitle("Administrator", for: .normal)
        adminButton.addTarget(self, action: #selector(adminButtonTapped), for: .touchUpInside)
        adminButton.layer.borderWidth = 1.0
        adminButton.layer.borderColor = UIColor.gray.cgColor
        adminButton.setTitleColor(.darkGray, for: .normal)
        adminButton.backgroundColor = .white
        adminButton.layer.cornerRadius = 15
        adminButton.translatesAutoresizingMaskIntoConstraints = false
        adminButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        adminButton.isEnabled = false
        
        view.addSubview(adminButton)
        
        userButton = UIButton(type: .system)
        userButton.setTitle("User", for: .normal)
        userButton.addTarget(self, action: #selector(userButtonTapped), for: .touchUpInside)
        userButton.layer.borderWidth = 1.0
        userButton.layer.borderColor = UIColor.gray.cgColor
        userButton.setTitleColor(.darkGray, for: .normal)
        userButton.backgroundColor = .white
        userButton.layer.cornerRadius = 15
        userButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        userButton.isEnabled = false
        userButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(userButton)
        
        role == "Administrator" ? adminButtonTapped() : userButtonTapped()
        // Add form elements to a stack
        let buttonsStack = UIStackView(arrangedSubviews: [adminButton, userButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 20
        buttonsStack.distribution = .fillEqually
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            positionTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            positionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsStack.topAnchor.constraint(equalTo: positionTextField.bottomAnchor, constant: 20),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStack.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        // Add Assign users button
        assignButton = UIButton()
        assignButton.setTitle("Assign Users", for: .normal)
        assignButton.addTarget(self, action: #selector(assignButtonTapped), for: .touchUpInside)
        assignButton.layer.borderWidth = 1.0
        assignButton.layer.borderColor = UIColor.gray.cgColor
        assignButton.setTitleColor(.white, for: .normal)
        assignButton.backgroundColor = .darkGray
        assignButton.layer.cornerRadius = 15
        assignButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        assignButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add Assign users button
        deleteButton = UIButton()
        deleteButton.setTitle("Delete Position", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.layer.borderWidth = 1.0
        deleteButton.layer.borderColor = UIColor.red.cgColor
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.backgroundColor = .white
        deleteButton.layer.cornerRadius = 15
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        editButtonsStack = UIStackView()
        editButtonsStack.axis = .horizontal
        editButtonsStack.distribution = .equalCentering
        editButtonsStack.addArrangedSubview(assignButton)
        editButtonsStack.addArrangedSubview(deleteButton)
        editButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(editButtonsStack)
        
        NSLayoutConstraint.activate([
            editButtonsStack.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -85),
            editButtonsStack.heightAnchor.constraint(equalToConstant: 55),
            editButtonsStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            editButtonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.widthAnchor.constraint(equalTo: editButtonsStack.widthAnchor, multiplier: 0.47),
            assignButton.widthAnchor.constraint(equalTo: editButtonsStack.widthAnchor, multiplier: 0.47),
        ])
    }
    
    // Use the textFieldDidChange method to capture text changes
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if text.count > 0 && text != currentPosition || initialRole != role {
                saveButton.isEnabled = true
            }
            else {
                saveButton.isEnabled = false
            }
        }
    }
    
    @objc func assignButtonTapped(){
        let assignVC = UsersTableViewController()
        assignVC.modalPresentationStyle = .formSheet
        assignVC.isEditMode = true
        assignVC.currentPosition = currentPosition
        assignVC.editPositionView = self
        assignVC.previouslyAssignedUsers = AddPositionViewController.assignedUsers
        
        present(assignVC, animated: true, completion: nil)
    }
    
    @objc func deleteButtonTapped() {
        
        // Create an alert to confirm deletion
        let alertController = UIAlertController(
            title: "Confirm Deletion",
            message: "Are you sure you want to delete this position?",
            preferredStyle: .alert
        )
        
        // Add Delete and Cancel actions
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.confirmDeletePosition()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    func confirmDeletePosition() {
        // Delete the position from the positions in the workspace
        if role == "Administrator" {
            if let index = Utils.workspace.positions.admins.firstIndex(of: currentPosition) {
                Utils.workspace.positions.admins.remove(at: index)
            }
        } else {
            if let index = Utils.workspace.positions.employees.firstIndex(of: currentPosition) {
                Utils.workspace.positions.employees.remove(at: index)
            }
        }
        
        // Set the position of every employee with that position to an empty string
        Utils.workspace.employees = Utils.workspace.employees.map { employee in
            var mutableEmployee = employee
            if employee.position == currentPosition {
                mutableEmployee.position = ""
            }
            return mutableEmployee
        }
        
        // Update the workspace on Firestore
        Workspace.updateWorkspace(workspace: Utils.workspace) { error in
            if let error = error {
                print("Error updating workspace: \(error.localizedDescription)")
            } else {
                print("Workspace updated successfully")
                // Reload table data or update UI as needed
                self.positionsTableView.reloadData()
            }
        }
        
        // Dismiss the current view controller
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func adminButtonTapped() {
        role = "Administrator"
        userButton.setTitleColor(.darkGray, for: .normal)
        userButton.backgroundColor = .white
        
        adminButton.setTitleColor(.white, for: .normal)
        adminButton.backgroundColor = .darkGray
        
        textFieldDidChange(positionTextField)
    }
    
    @objc func userButtonTapped() {
        role = "User"
        userButton.setTitleColor(.white, for: .normal)
        userButton.backgroundColor = .darkGray
        
        adminButton.setTitleColor(.darkGray, for: .normal)
        adminButton.backgroundColor = .white
        
        textFieldDidChange(positionTextField)
    }
    
    @objc func cancelButtonTapped() {
        positionTextField.text = currentPosition
        
        editButtonsStack.isHidden = false
        adminButton.isEnabled = false
        userButton.isEnabled = false
        
        navigationBar.items?.first?.rightBarButtonItem = editButton
        navigationBar.items?.first?.leftBarButtonItem = backButton
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    @objc func editButtonTapped() {
        // enable text field
        positionTextField.isEnabled = true
        navigationBar.items?.first?.rightBarButtonItem = saveButton
        navigationBar.items?.first?.leftBarButtonItem = cancelButton
        
        positionTextField.backgroundColor = .white
        adminButton.isEnabled = true
        userButton.isEnabled = true
        editButtonsStack.isHidden = true
    }
    
    // Function to handle the save button tap
    @objc func saveButtonTapped() {
        editButtonsStack.isHidden = false
        navigationBar.items?.first?.leftBarButtonItem = backButton
        
        let position = positionTextField.text!
        
        // Update position
        if role == "User" {
            Utils.workspace.positions.employees = Utils.workspace.positions.employees.map { positionItem in
                if positionItem == currentPosition {
                    return position
                } else {
                    return positionItem
                }
            }
        } else {
            Utils.workspace.positions.admins = Utils.workspace.positions.admins.map { positionItem in
                if positionItem == currentPosition {
                    return position
                } else {
                    return positionItem
                }
            }
        }
        
        // Update position for employees in the workspace
        Utils.workspace.employees = Utils.workspace.employees.map { employee in
            if employee.position == currentPosition {
                var mutableEmployee = employee
                mutableEmployee.position = position
                return mutableEmployee
            } else {
                return employee
            }
        }
        
        // Get the user IDs of all users in AddPositionViewController.assignedUsers
        let assignedUserIds = AddPositionViewController.assignedUsers.map { $0.id }
        
        
        // Get the user IDs of users that are in previouslyAssignedUsers but not in AddPositionViewController.assignedUsers
        let usersToRemoveIds = userIds.filter { !assignedUserIds.contains($0) }
    
        // Update the positions of users in the workspace with the IDs found in usersToRemoveIds
        Utils.workspace.employees = Utils.workspace.employees.map { employee in
            if usersToRemoveIds.contains(employee.employeeId) {
                var mutableEmployee = employee // Create a mutable copy of the employee
                mutableEmployee.position = "" // Update the position to an empty string
                return mutableEmployee
            } else {
                return employee // Return the employee as it is, without any changes
            }
        }
        
        Utils.workspace.employees = Utils.workspace.employees.map { employee in
            if assignedUserIds.contains(employee.employeeId) {
                var mutableEmployee = employee // Create a mutable copy of the employee
                mutableEmployee.position = position // Update the position for the selected employee
                return mutableEmployee
            } else {
                return employee // Return the employee as it is, without any changes
            }
        }
        
        Workspace.updateWorkspace(workspace: Utils.workspace) { error in
            if let error = error {
                print("Error updating workspace: \(error.localizedDescription)")
            } else {
                print("Workspace updated successfully")
                // reload table data
                self.positionsTableView.reloadData()
            }
        }
        
        AddPositionViewController.assignedUsers = []
        dismiss(animated: true, completion: nil)
    }
}
