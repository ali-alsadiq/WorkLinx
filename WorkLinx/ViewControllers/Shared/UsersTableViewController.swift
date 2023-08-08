//
//  UsersTableViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-01.
//

import UIKit

class UsersTableViewController: UIViewController {
    public var editPositionView: EditPositionViewController?
    public var addShiftsView: AddShiftViewController?
    public var isUsersView = false
    
    public var previouslyAssignedUsers: [User]?
    
    private var navigationBar: CustomNavigationBar!
    private var doneButton: UIBarButtonItem!
    private var cancelButton: UIBarButtonItem!
    private var addButton: UIBarButtonItem!
    private var backButton: BackButton!
    
    private var assignUsersTableView: UITableView!
    private var cell: AssignPositionCell!
    
    private var users: [User] = [] // Array to store fetched users
    
    public var isEditMode = false // set to true when editing
    public var currentPosition = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // Add nav bar
        navigationBar = CustomNavigationBar(title: isUsersView ? "Users" : "Add Users")
        cancelButton = UIBarButtonItem()
        cancelButton.title = "Cancel"
        cancelButton.action = #selector(canecel)
        
        doneButton = UIBarButtonItem()
        doneButton.title = "Done"
        doneButton.target = self
        doneButton.action = #selector(doneButtonTapped)
        doneButton.isEnabled = false
        
        backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        
        if isUsersView {
            if Utils.isAdmin {
                let addButtonImage = UIImage(systemName: "plus")
                // Resize and recolor the addButton image
                let symbolConfiguration = UIImage.SymbolConfiguration(weight: .heavy)
                let resizedImage = addButtonImage!.withConfiguration(symbolConfiguration).withTintColor(.black, renderingMode: .alwaysOriginal)
                addButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(addButtonTapped))
                
                navigationBar.items?.first?.rightBarButtonItem = addButton
            }
            navigationBar.items?.first?.leftBarButtonItem = backButton
        } else {
            navigationBar.items?.first?.leftBarButtonItem = cancelButton
            navigationBar.items?.first?.rightBarButtonItem = doneButton
        }
        
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
    
    // Function to handle the + button tap
    @objc func addButtonTapped() {
        let positionsVC = AddUserViewController()
        positionsVC.modalPresentationStyle = .fullScreen

        present(positionsVC, animated: true, completion: nil)
    }

    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func canecel() {
        
        // Empty assignedUsers array
        AddPositionViewController.assignedUsers = []
        
        // Clear all check marks
        cell.accessoryType = .none

        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() {
        if isEditMode && editPositionView != nil {
            editPositionView!.editButtonTapped()
            editPositionView!.saveButton.isEnabled = true
        }
        
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
}

extension UsersTableViewController: UITableViewDataSource, UITableViewDelegate {
    
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
            if addShiftsView == nil {
                cell.accessoryType = AddPositionViewController.assignedUsers.contains(where: { $0.id == user.id }) ? .checkmark : .none
            } else {
                cell.accessoryType = AddShiftViewController.assignedUsers.contains(where: { $0.id == user.id }) ? .checkmark : .none
            }
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
            
            if isUsersView {
                // navigate to a page where you can see users info, assign shifts, set position, etc...
                print(user)
                let userDetailVC = UserDetailsViewController(user: user)
                Utils.navigate(userDetailVC, self)
            }
            else if addShiftsView == nil {
                if AddPositionViewController.assignedUsers.contains(where: { $0.id == user.id }) {
                    AddPositionViewController.assignedUsers.removeAll(where: { $0.id == user.id })
                } else {
                    AddPositionViewController.assignedUsers.append(user)
                }
                tableView.reloadRows(at: [indexPath], with: .none)
                doneButton.isEnabled = (!isEditMode && !AddPositionViewController.assignedUsers.isEmpty) || (isEditMode && previouslyAssignedUsers != AddPositionViewController.assignedUsers)
            }
            else {
                if AddShiftViewController.assignedUsers.contains(where: { $0.id == user.id }) {
                    AddShiftViewController.assignedUsers.removeAll(where: { $0.id == user.id })
                    addShiftsView!.userManger.removeUser(user)
                } else {
                    AddShiftViewController.assignedUsers.append(user)
                    addShiftsView!.userManger.addUSer(user)
                }
                tableView.reloadRows(at: [indexPath], with: .none)
                doneButton.isEnabled = !AddShiftViewController.assignedUsers.isEmpty || previouslyAssignedUsers != AddShiftViewController.assignedUsers
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
