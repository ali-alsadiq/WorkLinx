//
//  SelectWorkPlaceViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-20.
//

import Foundation
import UIKit


class SelectWorkPlaceViewController: UIViewController {
    
    @IBOutlet weak var selectWorkplaceTable: UITableView!
    
    let data = Utils.getWorkspaceData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add nav bar
        let navigationBar = CustomNavigationBar(title: "Select Workspace")
        let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        
        navigationBar.items?.first?.leftBarButtonItem = backButton
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Set constraints for the table view
        selectWorkplaceTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectWorkplaceTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectWorkplaceTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectWorkplaceTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            selectWorkplaceTable.topAnchor.constraint(equalTo: navigationBar.bottomAnchor)
        ])
        
        //registration of the MoreCell which is a UITableViewCell
        selectWorkplaceTable.register(WorkspaceCell.self, forCellReuseIdentifier: "workspaceCell")
        selectWorkplaceTable.register(CreateWorkplaceCell.self, forCellReuseIdentifier: "createWorkplaceCell")
        
        selectWorkplaceTable.dataSource = self
        selectWorkplaceTable.delegate = self
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
}

extension SelectWorkPlaceViewController: UITableViewDelegate{
    // Change to go to the next view for each row using cellData.text
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionData = data[indexPath.section]
        let cellData = sectionData.1[indexPath.row]
        
        if let cellWorkspace = cellData as? CellWorkspace {
            Utils.user.defaultWorkspace = cellWorkspace.workspace
            Utils.navigate("DashboardView", self)
        } else if let createWorkspaceCell = cellData as? CellCreateWorkspace {
            if createWorkspaceCell.cellText.lowercased().contains("create".lowercased()){
                Utils.navigate("RegisterEmployerView", self)
            } else if createWorkspaceCell.cellText.lowercased().contains("joint".lowercased()){
                print("navigate to joining workspace page or show alert??")
            }
        }
    }
}


extension SelectWorkPlaceViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = data[section]
        return sectionData.1.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = data[indexPath.section]
        let cellData = sectionData.1[indexPath.row]

        if let cellWorkspace = cellData as? CellWorkspace {
            // Dequeue and configure the WorkspaceCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "workspaceCell", for: indexPath) as! WorkspaceCell
            cell.updateView(workspace: cellWorkspace.workspace, user: cellWorkspace.userType)
            return cell
        } else if let createWorkspaceCell = cellData as? CellCreateWorkspace {
            // Dequeue and configure the CreateWorkplaceCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "createWorkplaceCell", for: indexPath) as! CreateWorkplaceCell
            cell.updateView(cellText: createWorkspaceCell.cellText, icon: UIImage(systemName: createWorkspaceCell.icon)!)
            return cell
        }

        // If the cell type is not recognized, return a default cell
        return UITableViewCell()
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].0
    }
}
