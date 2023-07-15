//
//  DataProvider.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-15.
//

import Foundation

class DataProvider {

    static var workSpaces: [Workspace] = []
    static var users: [User] = []
    
    static func createData() {
        var employee1, employee2, admin1, admin2: User
        var workspace1, workspace2: Workspace
        
        // first workspace
        workspace1 = Workspace(name: "Workspace1",
                                   address: "456 Main St",
                                   admins: [],
                                   employees: [])
        
        employee1 = User(emailAddress: "user1@email.com",
                             password: "123123",
                             workSpacesAndPayRate: [(workspace1, 30)],
                             defaltWorkspace: workspace1)
        
        admin1 = User(emailAddress: "admin1@email.com",
                          password: "123123",
                          workSpacesAndPayRate: [(workspace1, 50)],
                          defaltWorkspace: workspace1)
        
        workspace1.admins?.append(admin1)
        workspace1.employees?.append(employee1)
        
        // Second workspace
        workspace2 = Workspace(name: "Workspace2",
                                   address: "123 Main St",
                                   admins: [],
                                   employees: [])
        
        employee2 = User(emailAddress: "user2@email.com",
                             password: "123123",
                             workSpacesAndPayRate: [(workspace2, 35)],
                             defaltWorkspace: workspace2)
        
        admin2 = User(emailAddress: "admin2@email.com",
                          password: "123123",
                          workSpacesAndPayRate: [(workspace2, 55)],
                          defaltWorkspace: workspace2)
        
        workspace2.admins?.append(admin2)
        workspace2.employees?.append(employee2)
        
        // Add to static vars
        workSpaces.append(workspace1)
        workSpaces.append(workspace2)
        
        users.append(employee1)
        users.append(employee2)
        users.append(admin1)
        users.append(admin2)

    }
}
