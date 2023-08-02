//
//  AddUserViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-02.
//

import UIKit
import SwiftUI

class AddUserViewController: UIViewController {

    private var navigationBar: CustomNavigationBar!
    private var emailTextField: CustomTextField!
    private var inviteButton: CustomButton!
    private let emailListManager = EmailListManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // Add nav bar
        navigationBar = CustomNavigationBar(title: "Add User")
        let backButton = BackButton(text: "Cancel", target: self, action: #selector(goBack))
        let saveButton = BackButton(text: "Save", target: self, action: #selector(saveButtonTapped))

        navigationBar.items?.first?.leftBarButtonItem = backButton
        navigationBar.items?.first?.rightBarButtonItem = saveButton

        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)

        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        emailTextField = CustomTextField(placeholder: "Email", textContentType: .emailAddress)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false

        inviteButton = CustomButton(label: "Invite")
        inviteButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        inviteButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(emailTextField)
        view.addSubview(inviteButton)

        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 55),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            inviteButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            inviteButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            inviteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        // Add the EmailListView below the Invite Button
        let emailListView = UIHostingController(rootView: EmailListView(emailListManager: emailListManager))
        emailListView.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(emailListView)
        view.addSubview(emailListView.view)

        NSLayoutConstraint.activate([
            emailListView.view.topAnchor.constraint(equalTo: inviteButton.bottomAnchor, constant: 20),
            emailListView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emailListView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emailListView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        emailListView.didMove(toParent: self)
    }

    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }

    @objc func saveButtonTapped() {
        // save invited user to workspace
        dismiss(animated: true, completion: nil)
    }

    @objc func addButtonTapped() {
        emailListManager.addEmail(emailTextField.text ?? "")
    }
}
