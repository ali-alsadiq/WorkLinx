//
//  DashboardViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-08.
//

import UIKit

class DashboardViewController: MenuBarViewController {
    
    var tableView = UITableView()
    var data: [(String, [CellDashboard])] = []
    
    override func viewWillAppear(_ animated: Bool) {
        data = Utils.getDashboardTableData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Workspace.getWorkspaceByID(workspaceID: Utils.workspace.workspaceId) { workspace in
            if workspace != nil {                
                Utils.workspace = workspace!
                
                Utils.fetchData {
                    // only fetch shifts and requests instead
                    Utils.fetchData {
                        self.data = Utils.getDashboardTableData()
                        self.tableView.reloadData()
                    }
                }
            }
        }
       
        
        view.backgroundColor = .white
        
        title = Utils.workspace.name
        
        // Set constraints for the table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: menuBarStack.topAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        //registration of the DashboardCell which is a UITableViewCell
        tableView.register(DashboardCell.self, forCellReuseIdentifier: "dashboardCell")
        tableView.dataSource = self
        tableView.delegate = self
        
    }
}

extension DashboardViewController: UITableViewDelegate{
    // Change to go to the next view for each row using cellData.text
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionData = data[indexPath.section]
        let cellData = sectionData.1[indexPath.row]
        switch cellData.text
        {
        case "All Requests", "Time Off", "Reimbursement", "My Time Off":
            let requestVC = RequestViewController() as UIViewController
            navigateToView(tab: cellData.text, view: requestVC)
        case "My Shifts", "Open Shifts":
            let scheduleVC = ScheduleViewController() as UIViewController
            navigateToView(tab: cellData.text, view: scheduleVC)
        default
            : break
        }
    }
    
    
    func navigateToView(tab: String, view: UIViewController)
    {
        if let requestVC = view as? RequestViewController {
            requestVC.isGoingBack = true
            requestVC.tab = tab
            requestVC.dashboardVC = self
            Utils.embedViewControllerInNavigationAndNavigate(self, to: requestVC)
        } else if let scheduleVC = view as? ScheduleViewController {
            scheduleVC.isGoingBack = true
            scheduleVC.tab = tab
            Utils.embedViewControllerInNavigationAndNavigate(self, to: scheduleVC)
        }
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
