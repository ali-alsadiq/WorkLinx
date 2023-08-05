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
        
        // fetch Data
        fetchData() {
            self.data = Utils.getDashboardTableData()
            self.tableView.reloadData()
        }
    }
    
    private func fetchWorkspaceUsers(completion: @escaping () -> Void) {
        let allEmployeeIds = Utils.workspace.employees.map { $0.employeeId }
        
        User.fetchUsersByIDs(userIDs: allEmployeeIds) { fetchedUsers in
            Utils.workSpaceUsers = fetchedUsers
            completion()
            
        }
    }
    
    private func fetchWorkspaceShifts(completion: @escaping () -> Void) {
        var allShiftIds = Utils.workspace.openShiftsIds
        allShiftIds.append(contentsOf: Utils.workspace.shiftIds)
        
        if allShiftIds.count > 0 {
            Shift.fetchShiftsByIDs(shiftIDs: allShiftIds) { fetchedShifts in
                
                Utils.workspaceOpenShifts = fetchedShifts.filter { $0.employeeIds.isEmpty }
                Utils.workspaceAssignedShifts = fetchedShifts.filter { !$0.employeeIds.isEmpty }
                Utils.currentUserShifts = fetchedShifts.filter { $0.employeeIds.contains(Utils.user.id) }
                completion()
            }
        }
    }
    
    func fetchData(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        fetchWorkspaceShifts {
            group.leave()
        }
        
        group.enter()
        fetchWorkspaceUsers {
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}

extension DashboardViewController: UITableViewDelegate{
    // Change to go to the next view for each row using cellData.text
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionData = data[indexPath.section]
        let cellData = sectionData.1[indexPath.row]
        switch cellData.text
        {
        case "All Requests", "Time Off", "Reimbursement" :
            let scheduleVC = RequestViewController() as UIViewController
            navigateToView(tab: cellData.text, view: scheduleVC)
        case "My Shifts", "Open Shifts":
            let scheduleVC = ScheduleViewController() as UIViewController
            navigateToView(tab: cellData.text, view: scheduleVC)
        case "My Time Off" :
            Utils.navigate(TimeOffViewController(), self)
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
