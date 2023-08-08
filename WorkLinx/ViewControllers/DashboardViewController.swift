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
        self.data = Utils.getDashboardTableData()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
                
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
            Utils.navigate(requestVC, self)
        } else if let scheduleVC = view as? ScheduleViewController {
            scheduleVC.isGoingBack = true
            scheduleVC.tab = tab
            Utils.navigate(scheduleVC, self)
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
