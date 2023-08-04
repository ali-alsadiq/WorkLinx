//
//  MessageViewController.swift
//  WorkLinx
//
//  Created by Alex Wang on 2023-08-04.
//

import UIKit
class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var myTable: UITableView!
    var users = ["John Smith", "Alice", "Bob", "Emma", "Michael"] // Add more user names here
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Add a custom navigation bar
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        // Add a back button to the navigation bar
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        let navigationItem = UINavigationItem(title: "Send Message")
        navigationItem.leftBarButtonItem = backButton
        navigationBar.setItems([navigationItem], animated: false)
        myTable = UITableView()
        myTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTable.delegate = self
        myTable.dataSource = self
        view.addSubview(myTable) // Add the table view as a subview
        myTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myTable.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            myTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Show chat messages for the selected user
        let selectedUser = users[indexPath.row]
        let chatVC = ChatViewController(selectedUser: selectedUser)
        let navController = UINavigationController(rootViewController: chatVC)
        present(navController, animated: true, completion: nil)
    }
}








