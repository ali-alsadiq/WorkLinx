//
//  User.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-15.
//

import Foundation

class User {
    var emailAddress: String
    var password: String
    var firstName: String?
    var lastName: String?
    var workSpacesAndPayRate: [(workspace: Workspace, payRate: Int)] = []
    var defaultWorkspace: Workspace?
    var position: String?
    var availability: [Shift] = []
    var timeOffRequests: [TimeOff] = []
    var shifts: [Shift] = []
    
    init(emailAddress: String, password: String) {
        self.emailAddress = emailAddress
        self.password = password
    }
}
