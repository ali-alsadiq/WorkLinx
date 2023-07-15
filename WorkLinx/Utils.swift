//
//  Utils.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-04.
//

import Foundation
import UIKit

struct Cell
{
    var icon: String
    var text: String
    var isExtendable: Bool
}

class Utils{
    static var emailAddress = ""
    static var password = ""
    
    static func getTableData(isManger: Bool) -> [(String, [Cell])]
    {
        var CallDataArray: [(String, [Cell])] = []
        
        // Get the user and check if is manger
        var isManger: Bool = isManger
        
        var userSection: [Cell] = []
        var workspaceSection: [Cell] = []
        var mangerSection: [Cell] = []
        
        // User section
        userSection.append(Cell(icon : "person.circle", text: "Profile Settings", isExtendable: true))
        userSection.append(Cell(icon : "bell", text: "Alert Prefrences", isExtendable: true))
        userSection.append(Cell(icon : "calendar", text: "Calendeat Sync", isExtendable: false))
        userSection.append(Cell(icon : "checkmark.circle", text: "Availabilty", isExtendable: true))
        userSection.append(Cell(icon : "list.clipboard", text: "My Hours", isExtendable: true))
        userSection.append(Cell(icon : "switch.2", text: "Switch Workplaces", isExtendable: true))
        userSection.append(Cell(icon : "power", text: "Log Out", isExtendable: false))
        if !isManger
        {
            userSection.append(Cell(icon : "trash", text: "Delete Profile", isExtendable: false))
        }

        // Workspace section
        workspaceSection.append(Cell (icon : "doc.plaintext", text: "Documents", isExtendable: true))
        workspaceSection.append(Cell (icon : "envelope", text: "Send Message", isExtendable: false))
        if isManger
        {
            workspaceSection.append(Cell (icon : "person", text: "Users", isExtendable: true))
            workspaceSection.append(Cell (icon : "person.text.rectangle", text: "Positions", isExtendable: true))
            workspaceSection.append(Cell (icon : "tag", text: "Tags", isExtendable: true))
            workspaceSection.append(Cell (icon : "location.north.circle", text: "Job Sites", isExtendable: true))
            workspaceSection.append(Cell (icon : "checklist", text: "Task Lists", isExtendable: true))
        }
        else
        {
            workspaceSection.append(Cell (icon : "person.3", text: "Coworkers", isExtendable: true))
        }
        
        // Manger section
        if isManger
        {
            mangerSection.append(Cell (icon : "antenna.radiowaves.left.and.right", text: "Publish & Notify", isExtendable: false))
            mangerSection.append(Cell (icon : "pin", text: "Add Annotation", isExtendable: true))
            mangerSection.append(Cell (icon : "person.badge.plus", text: "Import Users From Contacts", isExtendable: false))
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
