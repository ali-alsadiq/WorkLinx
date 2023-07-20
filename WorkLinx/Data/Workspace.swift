//
//  Workspace.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-15.
//

import Foundation

class Workspace {
    var name: String
    var address: String
    var admins: [User] = []
    var employees: [User] = []
    var openShifts: [Shift] = []
    
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
}
