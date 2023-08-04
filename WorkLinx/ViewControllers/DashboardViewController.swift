//
//  DashboardViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-08.
//

import UIKit

class DashboardViewController: MenuBarViewController {
        
    var tableView: UITableView!
    var data: [(String, [CellDashboard])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Workspace.updateInvitingWorkspaces() {
            if !Utils.invitingWorkspaces.isEmpty && !ConfirmInvitingWorkspacesViewController.isConfirmingInvitationLater {
                Utils.navigate(ConfirmInvitingWorkspacesViewController(), self)
            }
        }
        
        view.backgroundColor = .white
        
        tableView = UITableView()
        
        // Add nav bar
        let navigationBar = CustomNavigationBar(title: Utils.workspace.name)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(navigationBar)

        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Set constraints for the table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: menuBarStack.topAnchor),
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor)
        ])

        //registration of the DashboardCell which is a UITableViewCell
        tableView.register(DashboardCell.self, forCellReuseIdentifier: "dashboardCell")
        tableView.dataSource = self
        tableView.delegate = self

        self.data = Utils.getDashboardTableData()
        self.tableView.reloadData()

    }
}

extension DashboardViewController: UITableViewDelegate{
    // Change to go to the next view for each row using cellData.text
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionData = data[indexPath.section]
        let cellData = sectionData.1[indexPath.row]
        switch cellData.text
        {
        case "All Requests", "Time Off", "Reimbursemnt" :
             navigateToRequestView(tab: cellData.text)
        case "My Shifts" :
            let scheduleVC = ScheduleViewController()
            scheduleVC.isGoingBack = true
            Utils.navigate(scheduleVC, self)
        default
            : break
        }
    }
    
    func navigateToRequestView(tab: String)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RequestView") as! RequestViewController
        vc.isGoingBack = true
        vc.tab = tab
        
        Utils.navigate(vc, self)
    }
}

extension DashboardViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = data[section]
        return sectionData.1.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardCell", for: indexPath) as! DashboardCell
        
        let cellData = data[indexPath.section].1[indexPath.row]
        
        
        cell.updateView(
            number: cellData.number,
            text: cellData.text
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].0
    }
}
