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
    
    static func getDashboardTableData(completion: @escaping ([(String, [CellDashboard])]) -> Void) {

        // Fetch data related to the defaultWorkspace from Firestore
        let db = Firestore.firestore()
        
        // Create a main thread that runs multipe child threads
        // escape when main thread terminates
        
        // Create collection for timeOffRequests in Firebase
        // userId, workspaceId, startTime, endTime, isApproved
        // Count time off requests
        
        // count in thread 1
        let timeOffRequestsRef = db.collection("timeOffRequests").whereField("workspaceId", isEqualTo: workspace.workspaceId)
        timeOffRequestsRef.getDocuments { (snapshot, error) in
            if let error = error {
                // Handle the error if needed
                print("Error fetching time off requests: \(error)")
                return
            }
            
            let timeOffRequestsCount = snapshot?.documents.count ?? 0
            
            // count in thread 2
            // Count shift requests
            let shiftRequestsRef = db.collection("availabilities").whereField("workspaceId", isEqualTo: workspace.workspaceId)
            shiftRequestsRef.getDocuments { (snapshot, error) in
                if let error = error {
                    // Handle the error if needed
                    print("Error fetching shift requests: \(error)")
                    return
                }
                
                let shiftRequestsCount = snapshot?.documents.count ?? 0
                
                // Need to be fixed
                
                // Fetch user-specific data for the dashboard
//                let userShiftsCount = user.shiftIds.filter { shiftId in
//                    let shiftRef = db.collection("shifts").document(shiftId)
//                    return workspace.shiftIds.contains(shiftRef.documentID)
//                }.count
//
//                let userTimeOffRequestsCount = user.timeOffRequestIds.filter { requestId in
//                    let requestRef = db.collection("timeOffRequests").document(requestId)
//                    return workspace.timeOffRequestIds.contains(requestRef.documentID)
//                }.count
//
//                let userOpenShiftsCount = user.availabilityIds.filter { availabilityId in
//                    let availabilityRef = db.collection("availabilities").document(availabilityId)
//                    return workspace.availabilityIds.contains(availabilityRef.documentID)
//                }.count
//
                // Create dashboard data
                var callDataArray: [(String, [CellDashboard])] = []
                
                // Requests section
                var requestsSection: [CellDashboard] = []
                requestsSection.append(CellDashboard(number: timeOffRequestsCount, text: "Time Off Requests"))
                requestsSection.append(CellDashboard(number: shiftRequestsCount, text: "Shift Requests"))
                if isAdmin {
                    callDataArray.append(("Requests Needing Approval", requestsSection))
                }
                
                // Schedule section
//                var scheduleSection: [CellDashboard] = []
//                scheduleSection.append(CellDashboard(number: userShiftsCount, text: "My Shifts"))
//                if !isAdmin {
//                    scheduleSection.append(CellDashboard(number: userTimeOffRequestsCount, text: "Time Off Requests"))
//                    scheduleSection.append(CellDashboard(number: userOpenShiftsCount, text: "Shift Requests"))
//                }
//                let workSpaceOpenShifts = workspace.openShifts.count
//                scheduleSection.append(CellDashboard(number: workSpaceOpenShifts, text: "OpenShift Available"))
//
//                callDataArray.append(("My Schedule", scheduleSection))
                
                // Call the completion handler with the data
                completion(callDataArray)
            }
        }
    }
    
    
    
    static func getWorkspaceData(completion: @escaping ([(String, [Any])]) -> Void) {
        var CellDataArray: [(String, [Any])] = []
        
        var workspaces: [CellWorkspace] = []
        var createOrJoin: [CellCreateWorkspace] = []
        
        var userType: String!
        
        let dispatchGroup = DispatchGroup() // Create a dispatch group
        
        for item in Utils.user.workSpacesAndPayRate {
            dispatchGroup.enter() // Enter the dispatch group before starting the async call
            print("dispaching")
            Workspace.getWorkspaceByID(workspaceID: item.workspaceId) { workspace in
                if let workspace = workspace {
                    print(workspace.description)
                    userType = workspace.admins.contains(where: { $0 == Utils.user.id }) ? "Admin" : "Employee"
                    workspaces.append(CellWorkspace(workspace: workspace, userType: userType, isExtendable: false))
                    print(workspaces.count)
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
        userSection.append(CellUserProfile(titleLabel: "Position", textLabel: user.position))

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
    
    // Navigate using UIViewController
    static func navigate(_ vc: UIViewController,
                         _ sender: UIViewController,
                         transitionTime: Double = 0.2)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + transitionTime)
        {
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
}
