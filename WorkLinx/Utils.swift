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

class Utils{
    static var emailAddress = ""
    static var password = ""
    
    static func getDashboardTableData(isManger: Bool) -> [(String, [CellDashboard])]
    {
        var CallDataArray: [(String, [CellDashboard])] = []
        var requestsSection: [CellDashboard] = []
        var scheduleSection: [CellDashboard] = []
        
        // Workspace data
        requestsSection.append(CellDashboard(number: 0, text: "Time Off Requests"))
        requestsSection.append(CellDashboard(number: 0, text: "Shift Requests"))
        requestsSection.append(CellDashboard(number: 0, text: "OpenShift Requests"))
        
        // User data
        scheduleSection.append(CellDashboard(number: 0, text: "My Shifts"))
        
        if !isManger {
            // User Requests
            scheduleSection.append(CellDashboard(number: 0, text: "Time Off Requests"))
            scheduleSection.append(CellDashboard(number: 0, text: "Shift Requests"))
        }
        
        scheduleSection.append(CellDashboard(number: 0, text: "OpenShift Available"))
        
        if isManger {  CallDataArray.append(("Requests Needing Approval", requestsSection)) }
        CallDataArray.append(("My Schedule", scheduleSection))
        
        return CallDataArray
    }
    
    static func getMoreTableData(isManger: Bool) -> [(String, [CellMore])]
    {
        var CallDataArray: [(String, [CellMore])] = []
        
        var userSection: [CellMore] = []
        var workspaceSection: [CellMore] = []
        var mangerSection: [CellMore] = []
        
        // User section
        userSection.append(CellMore(icon : "person.circle", text: "Profile Settings", isExtendable: true))
        userSection.append(CellMore(icon : "bell", text: "Alert Prefrences", isExtendable: true))
        userSection.append(CellMore(icon : "calendar", text: "Calendeat Sync", isExtendable: false))
        userSection.append(CellMore(icon : "checkmark.circle", text: "Availabilty", isExtendable: true))
        userSection.append(CellMore(icon : "list.clipboard", text: "My Hours", isExtendable: true))
        userSection.append(CellMore(icon : "switch.2", text: "Switch Workplaces", isExtendable: true))
        userSection.append(CellMore(icon : "power", text: "Log Out", isExtendable: false))
        if !isManger
        {
            userSection.append(CellMore(icon : "trash", text: "Delete Profile", isExtendable: false))
        }

        // Workspace section
        workspaceSection.append(CellMore (icon : "doc.plaintext", text: "Documents", isExtendable: true))
        workspaceSection.append(CellMore (icon : "envelope", text: "Send Message", isExtendable: false))
        if isManger
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
        
        // Manger section
        if isManger
        {
            mangerSection.append(CellMore (icon : "antenna.radiowaves.left.and.right", text: "Publish & Notify", isExtendable: false))
            mangerSection.append(CellMore (icon : "pin", text: "Add Annotation", isExtendable: true))
            mangerSection.append(CellMore (icon : "person.badge.plus", text: "Import Users From Contacts", isExtendable: false))
        }
       
        // Replace with actual username and workspace name
        CallDataArray.append( ("UserName", userSection))
        CallDataArray.append(("WorkspaceName", workspaceSection))
        if isManger {  CallDataArray.append(("Manager Tools", mangerSection)) }
        
        return CallDataArray
    }
    
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
