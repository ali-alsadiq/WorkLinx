//
//  RegisterEmployerViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-04.
//

import UIKit

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
        
        // Create the UIButton
        let createButton = UIButton(type: .system)
        createButton.setTitle("Crerate Workspace", for: .normal)
        createButton.backgroundColor = .blue
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
        // Code to be executed when the button is tapped
        print("Create Button tapped!")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardView")
        
        Utils.navigate(vc, self)
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
}
