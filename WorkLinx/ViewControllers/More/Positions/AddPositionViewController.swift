//
//  AddPositionViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-01.
//

import Foundation
import UIKit

class AddPositionViewController: UIViewController {
    
    public var positionsTableView: PositionsViewController!
    
    private var navigationBar: CustomNavigationBar!
    private var saveButton: UIBarButtonItem!
    private var cancelButton: UIBarButtonItem!
    private var role: String?
    private var positionTextField: CustomTextField!
    private var adminButton: UIButton!
    private var userButton: UIButton!
    
    static var assignedUsers: [User] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // Add nav bar
        navigationBar = CustomNavigationBar(title: "Add Position")
        cancelButton = BackButton()
        cancelButton.action = #selector(goBack)
        
        saveButton = UIBarButtonItem()
        saveButton.title = "Save"
        saveButton.target = self
        saveButton.action = #selector(saveButtonTapped)
        saveButton.isEnabled = false
        
        navigationBar.items?.first?.leftBarButtonItem = cancelButton
        navigationBar.items?.first?.rightBarButtonItem = saveButton
        
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
        
        userButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userButton)
        
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
        let assignButton = UIButton()
        assignButton.setTitle("Assign Users", for: .normal)
        assignButton.addTarget(self, action: #selector(assignButtonTapped), for: .touchUpInside)
        assignButton.layer.borderWidth = 1.0
        assignButton.layer.borderColor = UIColor.gray.cgColor
        assignButton.setTitleColor(.white, for: .normal)
        assignButton.backgroundColor = .darkGray
        assignButton.layer.cornerRadius = 15
        assignButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        assignButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(assignButton)
        
        NSLayoutConstraint.activate([
            assignButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -85),
            assignButton.heightAnchor.constraint(equalToConstant: 55),
            assignButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            assignButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    // Use the textFieldDidChange method to capture text changes
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if text.count > 0 && role != nil{
                saveButton.isEnabled = true
            }
            else {
                saveButton.isEnabled = false
            }
        }
    }
    
    @objc func assignButtonTapped(){
        let assignVC = AssignUsersViewController()
        assignVC.modalPresentationStyle = .formSheet
        
        present(assignVC, animated: true, completion: nil)
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
    
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    // Function to handle the save button tap
    @objc func saveButtonTapped() {
        
        let position = positionTextField.text!
        
        // Check if the position already exists
        if role == "User" {
            if Utils.workspace.positions.employees.contains(position) {
                // Position already exists, show an alert
                showAlert(message: "Position '\(position)' already exists for employees.")
                return
            } else {
                Utils.workspace.positions.employees.append(position)
            }
        } else {
            if Utils.workspace.positions.admins.contains(position) {
                // Position already exists, show an alert
                showAlert(message: "Position '\(position)' already exists for administrators.")
                return
            } else {
                Utils.workspace.positions.admins.append(position)
            }
        }
        
        let employeeIds = AddPositionViewController.assignedUsers.map { $0.id }
        
        Utils.workspace.employees = Utils.workspace.employees.map { employee in
            if employeeIds.contains(employee.employeeId) {
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
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Position Already Exists", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
