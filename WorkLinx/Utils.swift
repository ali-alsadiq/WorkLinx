//
//  Utils.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-04.
//

import Foundation
import UIKit

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
    static var user = User(emailAddress: "", password: "")
    
    static func getDashboardTableData(isAdmin: Bool) -> [(String, [CellDashboard])]
    {
        var CallDataArray: [(String, [CellDashboard])] = []
        var requestsSection: [CellDashboard] = []
        var scheduleSection: [CellDashboard] = []
        
        // Workspace data
        let defaultWorkspace = user.defaultWorkspace!

        let timeOffRequests = defaultWorkspace.employees.flatMap { $0.timeOffRequests }
                                                    .filter { $0.workspace === defaultWorkspace }
                                                    .count
        requestsSection.append(CellDashboard(number: timeOffRequests, text: "Time Off Requests"))

        let shiftRequests = defaultWorkspace.employees.flatMap { $0.availability }
                                                     .filter { $0.workspace === defaultWorkspace }
                                                     .count
        requestsSection.append(CellDashboard(number: shiftRequests, text: "Shift Requests"))

        // User data
        let userShifts = user.shifts.filter { $0.workspace.name == user.defaultWorkspace?.name }.count
        scheduleSection.append(CellDashboard(number: userShifts, text: "My Shifts"))

        if !isAdmin {
            // User Requests
            let userTimeOffRequest = user.timeOffRequests.filter({$0.workspace.name == user.defaultWorkspace!.name}).count
            scheduleSection.append(CellDashboard(number: userTimeOffRequest, text: "Time Off Requests"))
            
            let userOpenShifts = user.availability.filter({$0.workspace.name == user.defaultWorkspace!.name}).count
            scheduleSection.append(CellDashboard(number: userOpenShifts, text: "Shift Requests"))
        }
        
        let workSpaceOpenShifts = user.defaultWorkspace!.openShifts.count
        scheduleSection.append(CellDashboard(number: workSpaceOpenShifts, text: "OpenShift Available"))

        if isAdmin {  CallDataArray.append(("Requests Needing Approval", requestsSection)) }
        CallDataArray.append(("My Schedule", scheduleSection))
        
        return CallDataArray
    }
    
    static func getWorkspaceData() -> [(String, [Any])]
    {
        var CellDataArray: [(String, [Any])] = []

        var workspaces: [CellWorkspace] = []
        var createOrJoin: [CellCreateWorkspace] = []

        var userType: String
        for item in Utils.user.workSpacesAndPayRate {
            userType = item.workspace.admins.contains(where: { $0 === Utils.user }) ? "Admin" : "Employee"
            workspaces.append(CellWorkspace(workspace: item.workspace, userType: userType, isExtendable: false))
        }

        createOrJoin.append(CellCreateWorkspace(cellText: "Join an Existing One", icon: "icloud.and.arrow.up"))
        createOrJoin.append(CellCreateWorkspace(cellText: "Create a New One", icon: "macwindow.badge.plus"))

        CellDataArray.append(("My Workspaces", workspaces))
        CellDataArray.append(("Looking for another workspace", createOrJoin))
        return CellDataArray
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
