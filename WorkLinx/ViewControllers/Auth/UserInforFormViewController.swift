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
        
        let confirmInvitingWorkspacesVC = ConfirmInvitingWorkspacesViewController()
        confirmInvitingWorkspacesVC.modalPresentationStyle = .fullScreen

        present(confirmInvitingWorkspacesVC, animated: true, completion: nil)
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
