//
//  UserProfileTableViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-23.
//

import Foundation
import UIKit

class UserProfileTableViewController: UIViewController {

    
    private var userProfileTableView: UITableView!

    var data: [(String, [CellUserProfile])] = [] // Initialize the data property with an empty array
    
    
    public var navigationBar: CustomNavigationBar!
    
    private var isEditingMode: Bool = false {
        didSet {
            userProfileTableView.reloadData()
            navigationItem.rightBarButtonItem = isEditingMode ? saveButton : editButton
        }
    }

    private lazy var editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
    private lazy var saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))

    override func viewDidLoad() {
        super.viewDidLoad()

        let fullName = Utils.user.firstName + " " + Utils.user.lastName
        navigationBar = CustomNavigationBar(title: fullName.count == 1 ? "Profile Settings" : fullName)

        let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        navigationBar.items?.first?.leftBarButtonItem = backButton
        navigationBar.items?.first?.rightBarButtonItem = editButton

        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)

    
        // Add table
        userProfileTableView = UITableView()
        userProfileTableView.register(UserProfileCell.self, forCellReuseIdentifier: "UserProfileCell")
        userProfileTableView.dataSource = self
        userProfileTableView.delegate = self
        userProfileTableView.contentInsetAdjustmentBehavior = .never
        
        userProfileTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userProfileTableView)

        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userProfileTableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            userProfileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userProfileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userProfileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        navigationBar.backgroundColor = .white
        view.backgroundColor = .white
        
        fetchDataForUserProfile()
    }
    
    func fetchDataForUserProfile() {
        self.data = Utils.getUserProfileTableData()
        self.userProfileTableView.reloadData()
    }

    @objc func editButtonTapped() {
        isEditingMode = true
        navigationBar.items?.first?.rightBarButtonItem = saveButton
    }

    @objc func saveButtonTapped() {
        // Save the updated user information
        // fix this
        let firstNameCell = userProfileTableView.cellForRow(at: IndexPath(row: 0, section: Utils.isAdmin ? 1 : 0)) as? UserProfileCell
        let lastNameCell = userProfileTableView.cellForRow(at: IndexPath(row: 1, section: Utils.isAdmin ? 1 : 0)) as? UserProfileCell
        let emailAddressCell = userProfileTableView.cellForRow(at: IndexPath(row: 2, section: Utils.isAdmin ? 1 : 0)) as? UserProfileCell
        let positionCell = userProfileTableView.cellForRow(at: IndexPath(row: 3, section: Utils.isAdmin ? 1 : 0)) as? UserProfileCell
        
        Utils.user.firstName = firstNameCell?.textField.text ?? ""
        Utils.user.lastName = lastNameCell?.textField.text ?? ""
        Utils.user.emailAddress = emailAddressCell?.textField.text ?? ""
        Utils.user.position = positionCell?.textField.text ?? ""

        print(Utils.user.description)
       
        fetchDataForUserProfile()

        navigationBar.items?.first?.rightBarButtonItem = editButton
        isEditingMode = false
    }

    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
}

extension UserProfileTableViewController: UITableViewDelegate{
    // Change to go to the next view for each row using cellData.text
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //handle onClick
    }
}

extension UserProfileTableViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = data[section]
        return sectionData.1.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! UserProfileCell
        
        let cellData = data[indexPath.section].1[indexPath.row]
        
        
        cell.updateView(title: cellData.titleLabel, value: cellData.textLabel, isEditing: isEditingMode)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].0
    }
}

