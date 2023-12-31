//
//  Utils.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-04.
//

import Foundation
import UIKit
import FirebaseFirestore


struct CellUserProfile
{
    var titleLabel: String
    var textLabel: String
}

struct CellMore
{
    var icon: String
    var text: String
    var isExtendable: Bool
}

struct CellDashboard
{
    var number: Int
    var text: String
}

struct CellWorkspace
{
    var workspace: Workspace
    var userType: String
    var isExtendable: Bool
}

struct CellCreateWorkspace{
    var cellText: String
    var icon: String
}

class Utils{
    static var workspace = Workspace(workspaceId: "", name: "", address: "", admins: [], employees: [])
    static var user = User(id: "", emailAddress: "", defaultWorkspaceId: "")
    static var password = ""
    static var isAdmin = true
    static var invitingWorkspaces: [Workspace] = []
    static var workSpaceUsers: [User] = []
    static var workspaceOpenShifts: [Shift] = []
    static var workspaceAssignedShifts: [Shift] = []
    static var currentUserShifts: [Shift] = [] // shuold be observer
    
    static var workSpceTimeOffs: [TimeOff] = []
    static var workspaceReimbursements: [Reimbursement] = []
    
    static var notModifiedByAdmiTimeOffs: [TimeOff] {
        Utils.workSpceTimeOffs.filter {!$0.isModifiedByAdmin}
    }
    
    static var notModifiedByAdminReimbursements: [Reimbursement] {
        Utils.workspaceReimbursements.filter {!$0.isModifiedByAdmin}
    }
    
    
    
    // colors
    static let darkOrange = UIColor(red: 0.8, green: 0.4, blue: 0.0, alpha: 1.0)
    static let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
    static let darkRed = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0)

    static let db = Firestore.firestore()
    
    static func encodeData(data: Encodable) throws -> [String: Any]? {
        do {
            // Encode the User instance to JSON data using JSONEncoder
            let jsonData = try JSONEncoder().encode(data)
            
            // Convert the JSON data to a dictionary
            guard let documentData = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                print("Error converting Data to dictionary.")
                return nil
            }
            
            return documentData
        } catch {
            print("Error encoding data: \(error.localizedDescription)")
            throw error // rethrow error
        }
    }
    
    static func getDashboardTableData() -> [(String, [CellDashboard])] {
        
        //fetch data here then contine adjusting
        
        // Create dashboard data
        var callDataArray: [(String, [CellDashboard])] = []
        
        // Requests section
        var requestsSection: [CellDashboard] = []
        let requestsCount =  notModifiedByAdmiTimeOffs.count + notModifiedByAdminReimbursements.count
        requestsSection.append(CellDashboard(number: requestsCount, text: "All Requests"))
        requestsSection.append(CellDashboard(number: notModifiedByAdmiTimeOffs.count, text: "Time Off"))
        requestsSection.append(CellDashboard(number:  notModifiedByAdminReimbursements.count, text: "Reimbursement"))
        
        if isAdmin {
            callDataArray.append(("Requests Needing Approval", requestsSection))
        }
        
        // Schedule section
        var scheduleSection: [CellDashboard] = []
        scheduleSection.append(CellDashboard(number: Utils.currentUserShifts.count, text: "My Shifts"))
        scheduleSection.append(CellDashboard(number: Utils.workspace.openShiftsIds.count, text: "Open Shifts"))
        scheduleSection.append(CellDashboard(number: Utils.workSpceTimeOffs.filter{$0.userId == Utils.user.id}.count, text: "My Time Off"))
        
        callDataArray.append(("My Schedule", scheduleSection))
        
        return callDataArray
    }
    
    
    
    
    static func getWorkspaceData(completion: @escaping ([(String, [Any])]) -> Void) {
        var CellDataArray: [(String, [Any])] = []
        
        var workspaces: [CellWorkspace] = []
        var createOrJoin: [CellCreateWorkspace] = []
        
        var userType: String!
        
        let dispatchGroup = DispatchGroup() // Create a dispatch group
        
        for workspaceId in Utils.user.workSpaces {
            dispatchGroup.enter() // Enter the dispatch group before starting the async call
            Workspace.getWorkspaceByID(workspaceID: workspaceId) { workspace in
                if let workspace = workspace {
                    userType = workspace.admins.contains(where: { $0 == Utils.user.id }) ? "Admin" : "Employee"
                    workspaces.append(CellWorkspace(workspace: workspace, userType: userType, isExtendable: false))
                } else {
                    print("Error getting workspace by Id")
                }
                dispatchGroup.leave() // Leave the dispatch group when the async call completes
            }
        }
        
        // Notify the completion handler when all async calls complete
        dispatchGroup.notify(queue: .main) {
            createOrJoin.append(CellCreateWorkspace(cellText: "Join an Existing One", icon: "icloud.and.arrow.up"))
            createOrJoin.append(CellCreateWorkspace(cellText: "Create a New One", icon: "macwindow.badge.plus"))
            
            CellDataArray.append(("My Workspaces", workspaces))
            CellDataArray.append(("Looking for another workspace", createOrJoin))
            
            completion(CellDataArray) // Call the completion handler with the fetched data
        }
    }
    
    static func getPositionsData() -> [(String, [String])]
    {
        var CallDataArray: [(String, [String])] = []
        let adminsSection = workspace.positions.admins.sorted()
        let employeesSection = workspace.positions.employees.sorted()
        
        if  adminsSection.count > 0 {
            CallDataArray.append(("Admins Positions", adminsSection))
        }
        
        if  employeesSection.count > 0 {
            CallDataArray.append(("Employees Positions", employeesSection))
        }
        
        return CallDataArray
    }
    
    
    static func getMoreTableData(isAdmin: Bool) -> [(String, [CellMore])]
    {
        var CallDataArray: [(String, [CellMore])] = []
        
        var userSection: [CellMore] = []
        var workspaceSection: [CellMore] = []
        var adminSection: [CellMore] = []
        
        // User section
        userSection.append(CellMore(icon : "person.circle", text: "Profile Settings", isExtendable: true))
        userSection.append(CellMore(icon : "bell", text: "Alert Prefrences", isExtendable: true))
        userSection.append(CellMore(icon : "calendar", text: "Calendar Sync", isExtendable: false))
        userSection.append(CellMore(icon : "checkmark.circle", text: "Availabilty", isExtendable: true))
        userSection.append(CellMore(icon : "list.clipboard", text: "My Hours", isExtendable: true))
        userSection.append(CellMore(icon : "switch.2", text: "Switch Workplaces", isExtendable: true))
        userSection.append(CellMore(icon : "power", text: "Log Out", isExtendable: false))
        if !isAdmin
        {
            userSection.append(CellMore(icon : "trash", text: "Delete Profile", isExtendable: false))
        }
        
        // Workspace section
        workspaceSection.append(CellMore (icon : "doc.plaintext", text: "Documents", isExtendable: true))
        workspaceSection.append(CellMore (icon : "envelope", text: "Send Message", isExtendable: false))
        if isAdmin
        {
            workspaceSection.append(CellMore (icon : "person", text: "Users", isExtendable: true))
            workspaceSection.append(CellMore (icon : "person.text.rectangle", text: "Positions", isExtendable: true))
            workspaceSection.append(CellMore (icon : "tag", text: "Tags", isExtendable: true))
            workspaceSection.append(CellMore (icon : "location.north.circle", text: "Job Sites", isExtendable: true))
            workspaceSection.append(CellMore (icon : "checklist", text: "Task Lists", isExtendable: true))
        }
        else
        {
            workspaceSection.append(CellMore (icon : "person.3", text: "Coworkers", isExtendable: true))
        }
        
        // Admin section
        if isAdmin
        {
            adminSection.append(CellMore (icon : "antenna.radiowaves.left.and.right", text: "Publish & Notify", isExtendable: false))
            adminSection.append(CellMore (icon : "pin", text: "Add Annotation", isExtendable: true))
            adminSection.append(CellMore (icon : "person.badge.plus", text: "Import Users From Contacts", isExtendable: false))
        }
        
        // Replace with actual username and workspace name
        CallDataArray.append( ("UserName", userSection))
        CallDataArray.append(("WorkspaceName", workspaceSection))
        if isAdmin {  CallDataArray.append(("Manager Tools", adminSection)) }
        
        return CallDataArray
    }
    
    static func getUserProfileTableData() -> [(String, [CellUserProfile])] {
        var CallDataArray: [(String, [CellUserProfile])] = []
        
        var userSection: [CellUserProfile] = []
        
        userSection.append(CellUserProfile(titleLabel: "First Name", textLabel: user.firstName))
        userSection.append(CellUserProfile(titleLabel: "Last Name", textLabel: user.lastName))
        userSection.append(CellUserProfile(titleLabel: "Email Address", textLabel: user.emailAddress))
        
        if isAdmin {
            
            var workspaceSection: [CellUserProfile] = []
            
            workspaceSection.append(CellUserProfile(titleLabel: "Workspace Name", textLabel: workspace.name))
            workspaceSection.append(CellUserProfile(titleLabel: "Workspace Address", textLabel: workspace.address))
            
            CallDataArray.append(("Workspace Profile", workspaceSection))
        }
        
        CallDataArray.append(("User Profile", userSection))
        
        return CallDataArray
    }
    
    // Navigate using Storyboard ID
    static func navigate(_ storyboardId: String,
                         _ sender: UIViewController,
                         transitionTime: Double = 0.2)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + transitionTime)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: storyboardId)
            
            vc.modalPresentationStyle = .fullScreen
            
            // Customize the transition animation
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .fade
            transition.subtype = .fromBottom
            sender.view.window?.layer.add(transition, forKey: kCATransition)
            
            sender.present(vc, animated: false, completion: nil)
        }
    }
    
    static func embedViewControllerInNavigationAndSetAsRoot(_ viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = navigationController
        }
    }
    
    static func embedViewControllerInNavigationAndNavigate(_ sourceViewController: UIViewController, to destinationViewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: destinationViewController)
        Utils.navigate(navigationController, sourceViewController)
    }


    
    // Navigate using UIViewController
    static func navigate(_ vc: UIViewController,
                         _ sender: UIViewController,
                         delayTime: Double = 0)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
            vc.modalPresentationStyle = .fullScreen
            
            // Customize the transition animation
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .fade
            transition.subtype = .fromBottom
            sender.view.window?.layer.add(transition, forKey: kCATransition)
            
            
            sender.present(vc, animated: false, completion: nil)
        }
    }
    
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]{2,}@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func showAlert(title: String, message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func createButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        
        // Set background color for normal state
        button.backgroundColor = .lightGray
        
        // Set custom background image for selected state
        let selectedColor = UIColor(red: 0.2, green: 0.5, blue: 0.8, alpha: 1.0)
        let selectedImage = image(withColor: selectedColor, cornerRadius: 5)
        button.setBackgroundImage(selectedImage, for: .selected)
        
        return button
    }
    
    static func image(withColor color: UIColor, cornerRadius: CGFloat) -> UIImage {
        let size = CGSize(width: cornerRadius * 2 + 1, height: cornerRadius * 2 + 1)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            color.setFill()
            let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius)
            path.fill()
        }
        return image.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
    }
    
    static func formattedDateWithDayName(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    
    // fetch workspace data
    static func fetchWorkspaceUsers(completion: @escaping () -> Void) {
        let allEmployeeIds = Utils.workspace.employees.map { $0.employeeId }
        
        User.fetchUsersByIDs(userIDs: allEmployeeIds) { fetchedUsers in
            Utils.workSpaceUsers = fetchedUsers
            completion()
        }
    }
    
    static func fetchWorkspaceShifts(completion: @escaping () -> Void) {
        var allShiftIds = Utils.workspace.shiftIds + Utils.workspace.openShiftsIds
        allShiftIds.append(contentsOf: Utils.workspace.shiftIds)
        
        if allShiftIds.count > 0 {
            Shift.fetchShiftsByIDs(shiftIDs: allShiftIds) { fetchedShifts in
                
                Utils.workspaceOpenShifts = fetchedShifts.filter { $0.employeeIds.isEmpty }
                Utils.workspaceAssignedShifts = fetchedShifts.filter { !$0.employeeIds.isEmpty }
                Utils.currentUserShifts = fetchedShifts.filter { $0.employeeIds.contains(Utils.user.id) }
                completion()
            }
        } else {
            Utils.workspaceOpenShifts = []
            Utils.workspaceAssignedShifts = []
            Utils.currentUserShifts = []
            completion()
        }
    }
    
    static func fetchTimeOffRequests(completion: @escaping () -> Void) {
        let timeOffRequestIds = Utils.workspace.timeOffRequestIds
        
        if timeOffRequestIds.count > 0 {
            TimeOff.fetchtimeOffsByIDs(timeOffIDs: Utils.workspace.timeOffRequestIds) { fetchedTimeOffRequests in
                Utils.workSpceTimeOffs = fetchedTimeOffRequests
                completion()
            }
        } else {
            Utils.workSpceTimeOffs = []
            completion()
        }
    }
    
    static func fetchReimbursementRequests(completion: @escaping () -> Void) {
        let reimbursementRequestIds = Utils.workspace.reimbursementRequestIds
        
        if reimbursementRequestIds.count > 0 {
            Reimbursement.fetchReimbursementsByIDs(reimbursementOffIDs: reimbursementRequestIds) { fetchedReimbursementRequestIds in
                Utils.workspaceReimbursements = fetchedReimbursementRequestIds
                completion()
            }
        } else {
            Utils.workspaceReimbursements = []
            completion()
        }
    }
    
    static func fetchData(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        fetchWorkspaceShifts {
            group.leave()
        }
        
        group.enter()
        fetchWorkspaceUsers {
            group.leave()
        }
        
        group.enter()
        fetchTimeOffRequests {
            group.leave()
        }
        
        group.enter()
        fetchReimbursementRequests {
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}
