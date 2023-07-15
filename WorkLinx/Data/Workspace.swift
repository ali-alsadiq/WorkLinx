//
//  Workspace.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-15.
//

import Foundation

struct Workspace {
    var name: String
    var address: String
    var admins: [User] = []
    var employees: [User] = []
    var openShifts: [Shift]?
    var shiftRequest: [Shift]?
    var timeOffRequests: [TimeOff]?
}


