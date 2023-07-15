//
//  User.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-15.
//

import Foundation

struct User {
    var emailAddress: String
    var password: String
    var firstName: String?
    var lastName: String?
    var workSpacesAndPayRate: [(Workspace, Int)]?
    var defaltWorkspace: Workspace?
    var position: String?
    var availabilty: [Shift]?
    var timeOffRequests: [TimeOff]?
    var shifts: [Shift]?
    
}
