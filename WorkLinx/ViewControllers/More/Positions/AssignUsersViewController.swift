//
//  AssignUsersViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-01.
//

import UIKit

class AssignUsersViewController: UIViewController {
    public var editView: EditPositionViewController?
    public var previouslyAssignedUsers: [User]?
    
    private var navigationBar: CustomNavigationBar!
    private var doneButton: UIBarButtonItem!
    private var cancelButton: UIBarButtonItem!
    
    private var assignUsersTableView: UITableView!
    private var cell: AssignPositionCell!
    
    private var users: [User] = [] // Array to store fetched users
    
    public var isEditMode = false // set to true when editing
    public var currentPosition = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // Add nav bar
        navigationBar = CustomNavigationBar(title: "Add Position")
        cancelButton = UIBarButtonItem()
        cancelButton.title = "Cancel"
        cancelButton.action = #selector(goBack)
        
        doneButton = UIBarButtonItem()
        doneButton.title = "Done"
        doneButton.target = self
        doneButton.action = #selector(doneButtonTapped)
        doneButton.isEnabled = false
        
        navigationBar.items?.first?.leftBarButtonItem = cancelButton
        navigationBar.items?.first?.rightBarButtonItem = doneButton
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Fetch users by IDs
        let employeeIds = Utils.workspace.employees.map { $0.employeeId }
        User.fetchUsersByIDs(userIDs: employeeIds) { [weak self] fetchedUsers in
            self?.users = fetchedUsers
            self?.setupTableView() // Set up the table view after fetching users
        }
        
        if isEditMode {
            // Filter employees to get only those whose positions match the current position
            let filteredEmployees = Utils.workspace.employees.filter { $0.position == currentPosition }

            // Extract user IDs from the filtered employees
            let userIds = filteredEmployees.map { $0.employeeId }
            
            if userIds.count > 0 {
                // Fetch users by IDs
                User.fetchUsersByIDs(userIDs: userIds) { fetchedUsers in
                    // Assign fetched users to AddPositionViewController.assignedUsers
                    AddPositionViewController.assignedUsers = fetchedUsers
                }
            }
            self.setupTableView()
        }
    }
    
    
    private func setupTableView() {
        // Set up the table view
        assignUsersTableView = UITableView()
        assignUsersTableView.dataSource = self
        assignUsersTableView.delegate = self
        assignUsersTableView.translatesAutoresizingMaskIntoConstraints = false
        assignUsersTableView.register(AssignPositionCell.self, forCellReuseIdentifier: "AssignPositionCell")
        
        view.addSubview(assignUsersTableView)
        
        NSLayoutConstraint.activate([
            assignUsersTableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            assignUsersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            assignUsersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            assignUsersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    @objc func goBack() {
        
        // Empty assignedUsers array
        AddPositionViewController.assignedUsers = []
        
        // Clear all check marks
        cell.accessoryType = .none

        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() {
        if isEditMode && editView != nil {
            editView!.editButtonTapped()
            editView!.saveButton.isEnabled = true
        }
        
        
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
}

extension AssignUsersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Dictionary(grouping: users, by: { $0.firstName.prefix(1).uppercased() }).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let firstLetters = Dictionary(grouping: users, by: { $0.firstName.prefix(1).uppercased() })
        let sortedKeys = firstLetters.keys.sorted()
        let key = sortedKeys[section]
        return firstLetters[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "AssignPositionCell", for: indexPath) as? AssignPositionCell
        let firstLetters = Dictionary(grouping: users, by: { $0.firstName.prefix(1).uppercased() })
        let sortedKeys = firstLetters.keys.sorted()
        let key = sortedKeys[indexPath.section]
        if let user = firstLetters[key]?[indexPath.row] {
            cell.firstNameLabel.text = user.firstName
            cell.lastNameLabel.text = user.lastName
            // Add check mark if the user is already selected in AddPositionViewController.assignedUsers
            cell.accessoryType = AddPositionViewController.assignedUsers.contains(where: { $0.id == user.id }) ? .checkmark : .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let firstLetters = Dictionary(grouping: users, by: { $0.firstName.prefix(1).uppercased() })
        let sortedKeys = firstLetters.keys.sorted()
        return sortedKeys[section]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let firstLetters = Dictionary(grouping: users, by: { $0.firstName.prefix(1).uppercased() })
        let sortedKeys = firstLetters.keys.sorted()
        let key = sortedKeys[indexPath.section]
        if let user = firstLetters[key]?[indexPath.row] {
            if AddPositionViewController.assignedUsers.contains(where: { $0.id == user.id }) {
                AddPositionViewController.assignedUsers.removeAll(where: { $0.id == user.id })
            } else {
                AddPositionViewController.assignedUsers.append(user)
            }
            tableView.reloadRows(at: [indexPath], with: .none)
            doneButton.isEnabled = !AddPositionViewController.assignedUsers.isEmpty || isEditMode
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
