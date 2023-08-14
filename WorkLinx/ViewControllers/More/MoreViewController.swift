//
//  MoreViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-08.
//

import UIKit


class MoreViewController : MenuBarViewController {
    
    let tableView = UITableView()
    var data = Utils.getMoreTableData(isAdmin: Utils.workspace.admins.contains(where: { $0 == Utils.user.id }))
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = "More"
        
        data = Utils.getMoreTableData(isAdmin: Utils.workspace.admins.contains(where: { $0 == Utils.user.id }))
       
        // Set constraints for the table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: menuBarStack.topAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        //registration of the MoreCell which is a UITableViewCell
        tableView.register(MoreCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func showLogoutAlert() {
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        let logoutAction = UIAlertAction(title: "Log Out", style: .destructive) { (_) in
            // Perform the logout action here
            print("Logged out successfully!")
            Utils.user = User(id: "", emailAddress: "", defaultWorkspaceId: "")
            Utils.invitingWorkspaces = []
            Utils.workspace = Workspace(workspaceId: "", name: "", address: "", admins: [], employees: [])
            ConfirmInvitingWorkspacesViewController.isConfirmingInvitationLater = false
            Utils.currentUserShifts = []
            Utils.workSpaceUsers = []
            Utils.workspaceAssignedShifts = []
            
            // Go back to splash screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SplashView")
            
            Utils.embedViewControllerInNavigationAndSetAsRoot(vc)
        }
        alertController.addAction(logoutAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func showDeleteProfileAlert() {
        let alertController = UIAlertController(title: "Delete Profile", message: "Are you sure you want to delete your profile?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            // Perform the delete profile action here
            // Remove from workspaces and users array in DB
            print("Profile deleted successfully!")
            Utils.user = User(id: "", emailAddress: "", defaultWorkspaceId: "")
            
            // Go back to splash screen
            Utils.navigate("SplashView", self, transitionTime: 0.4)
        }
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

extension MoreViewController: UITableViewDelegate{
    // Change to go to the next view for each row using cellData.text
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionData = data[indexPath.section]
        let cellData = sectionData.1[indexPath.row]
        
        switch(cellData.text)
        {
            case "Profile Settings":
                navigateToProfileSettings()
            case "Alert Prefrences":
                print(cellData.text)
            case "Calendar Sync":
                print(cellData.text)
            case "Availabilty":
                navigateToAvailabilty()
            case "My Hours":
                print(cellData.text)
            case "Switch Workplaces":
                Utils.navigate("SelectWorkplace", self)
            case "Log Out":
                showLogoutAlert()
            case "Delete Profile":
                showDeleteProfileAlert()
            case "Documents":
                navigateToDocumentsViewController()
            case "Send Message":
                navigateToMessageViewController()
            case "Users":
                navigateToUsersViewController()
            case "Positions":
                navigateToPositionsViewController()
            case "Tags":
                print(cellData.text)
            case "Job Sites":
                print(cellData.text)
            case "Task Lists":
                print(cellData.text)
            case "Coworkers":
                navigateToUsersViewController()
            case "Publish & Notify":
                print(cellData.text)
            case "Add Annotation":
                print(cellData.text)
            case "Import Users From Contacts":
                print(cellData.text)
            default:
                break
        }
    }
    
    func navigateToUsersViewController() {
        let usersVC = UsersTableViewController()
        usersVC.isUsersView = true
        usersVC.modalPresentationStyle = .fullScreen
        present(usersVC, animated: true, completion: nil)
    }
    
    func navigateToProfileSettings() {
        let userProfileVC = UserProfileTableViewController()
        
        // Present the UserProfileTableViewController modally
        userProfileVC.modalPresentationStyle = .fullScreen
        present(userProfileVC, animated: true, completion: nil)
    }
    
    func navigateToPositionsViewController() {
        let positionsVC = PositionsViewController()
        positionsVC.modalPresentationStyle = .fullScreen

        present(positionsVC, animated: true, completion: nil)
    }
    
    func navigateToMessageViewController(){
        let messageVC = MessageViewController()
        messageVC.modalPresentationStyle = .fullScreen
        present(messageVC, animated: true, completion: nil)
        
    }
    
    func navigateToDocumentsViewController() {
        let documentsVC = DocumentsViewController()
        documentsVC.modalPresentationStyle = .fullScreen

        present(documentsVC, animated: true, completion: nil)
    }
    
    func navigateToAvailabilty() {
        let availabitlyVC = AvailabilityViewController()

        if !Utils.user.availabilityIds.isEmpty {
            Availability.fetchAvailabilitesByIDs(availabilityIDs: Utils.user.availabilityIds) { userAvailabilties in
                availabitlyVC.currentAvailabilty = userAvailabilties.first {$0.workSpaceId == Utils.workspace.workspaceId}
                Utils.navigate(availabitlyVC, self)
            }
        } else {
            Utils.navigate(availabitlyVC, self)
        }
       
    }
}

    

extension MoreViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = data[section]
        return sectionData.1.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoreCell
        
        let cellData = data[indexPath.section].1[indexPath.row]
        
        
        cell.updateView(
            icon: UIImage(systemName: cellData.icon),
            text: cellData.text,
            arrow: UIImage(systemName:  cellData.isExtendable ? "chevron.right" : "")
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].0
    }
}
