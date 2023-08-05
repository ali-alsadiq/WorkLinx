//
//  UsersViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-02.
//

import UIKit

class UsersViewController: UIViewController {
    
    private var navigationBar: CustomNavigationBar!
    private var usersTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // Add nav bar
        navigationBar = CustomNavigationBar(title: "Users")
        let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        
        if Utils.isAdmin {
            let addButtonImage = UIImage(systemName: "plus")
            // Resize and recolor the addButton image
            let symbolConfiguration = UIImage.SymbolConfiguration(weight: .heavy)
            let resizedImage = addButtonImage!.withConfiguration(symbolConfiguration).withTintColor(.black, renderingMode: .alwaysOriginal)
            let addButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(addButtonTapped))
            
            navigationBar.items?.first?.rightBarButtonItem = addButton
        }
        
        navigationBar.items?.first?.leftBarButtonItem = backButton
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        // Add users table and invited user table
        usersTable = UITableView()
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    // Function to handle the + button tap
    @objc func addButtonTapped() {
        let positionsVC = AddUserViewController()
        positionsVC.modalPresentationStyle = .fullScreen

        present(positionsVC, animated: true, completion: nil)
    }
}
