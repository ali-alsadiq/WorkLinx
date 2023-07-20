//
//  DataProvider.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-15.
//

import Foundation

class DataProvider {
    
    
    static var employee1 = User(emailAddress: "john@email.com", password: "123123")
    static var employee2 = User(emailAddress: "emma@email.com", password: "123123")
    static var employee3 = User(emailAddress: "mike@email.com", password: "123123")
    static var employee4 = User(emailAddress: "sarah@email.com", password: "123123")
    
    static var users: [User] = [employee1, employee2, employee3, employee4]

    static let workspace1 = Workspace(name: "Tech Solutions Inc.", address: "123 Main St")
    static let workspace2 = Workspace(name: "Creative Studios", address: "456 Park Ave")
    
    static var workSpaces: [Workspace] = [workspace1, workspace2]

    static func createData() {
        // Assign workspace and pay rate to each employee
        employee1.workSpacesAndPayRate.append((workspace1, 30))
        employee2.workSpacesAndPayRate.append((workspace1, 30))
        employee3.workSpacesAndPayRate.append((workspace1, 30))
        employee4.workSpacesAndPayRate.append((workspace1, 30))

        employee3.workSpacesAndPayRate.append((workspace2, 35))
        employee4.workSpacesAndPayRate.append((workspace2, 35))
        
        // Set default workspace for each employee
        employee1.defaultWorkspace = workspace1
        employee2.defaultWorkspace = workspace1
        
        employee3.defaultWorkspace = workspace2
        employee4.defaultWorkspace = workspace2
        
        // Create Employee shifts
        createEmployeeShifts()
        
        // Add employees and admins to workspaces
        workspace1.employees.append(contentsOf: [employee1, employee2, employee3, employee4])
        workspace2.employees.append(contentsOf: [employee3, employee4])
        workspace1.admins.append(employee1)
        workspace2.admins.append(employee3)
        
        // Set the default workspace for each user
        employee1.defaultWorkspace = workspace1
        employee2.defaultWorkspace = workspace1
        employee3.defaultWorkspace = workspace2
        employee4.defaultWorkspace = workspace2

        // Add openShifts
        createOpenShifts()

        // Add user availabitly
        addUserAvailability()
        
        // Create TimeOffRequests
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        // Create time off requests for employee1

        let timeOffRequest1Employee1 = TimeOff(startTime: dateFormatter.date(from: "2023-08-03 09:00")!, endTime: dateFormatter.date(from: "2023-08-03 13:00")!)
        let timeOffRequest2Employee1 = TimeOff(startTime: dateFormatter.date(from: "2023-08-10 09:00")!, endTime: dateFormatter.date(from: "2023-08-10 17:00")!)
        
        employee1.timeOffRequests.append(contentsOf: [(workspace1, timeOffRequest1Employee1), (workspace2, timeOffRequest2Employee1)])
        
        // Create time off requests for employee2
        let timeOffRequest1Employee2 = TimeOff(startTime: dateFormatter.date(from: "2023-08-05 09:00")!, endTime: dateFormatter.date(from: "2023-08-05 15:00")!)
        
        employee2.timeOffRequests.append((workspace1, timeOffRequest1Employee2))
        
        // Create time off requests for employee3
        let timeOffRequest1Employee3 = TimeOff(startTime: dateFormatter.date(from: "2023-08-02 12:00")!, endTime: dateFormatter.date(from: "2023-08-02 16:00")!)
        
        employee3.timeOffRequests.append((workspace2, timeOffRequest1Employee3))
        
        // Create time off requests for employee4
        let timeOffRequest1Employee4 = TimeOff(startTime: dateFormatter.date(from: "2023-08-07 14:00")!, endTime: dateFormatter.date(from: "2023-08-07 18:00")!)
        
        employee4.timeOffRequests.append((workspace2, timeOffRequest1Employee4))
    }
    
    static func createOpenShifts() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        // Create open shifts for workspace1
        let workspace1 = workSpaces[0]
        let openShift1Workspace1 = Shift(location: workspace1.address, employee: nil, startTime: dateFormatter.date(from: "2023-08-10 08:00")!, endTime: dateFormatter.date(from: "2023-08-10 16:00")!)
        let openShift2Workspace1 = Shift(location: workspace1.address, employee: nil, startTime: dateFormatter.date(from: "2023-08-11 08:00")!, endTime: dateFormatter.date(from: "2023-08-11 16:00")!)
        
        workspace1.openShifts.append(contentsOf: [openShift1Workspace1, openShift2Workspace1])
        
        // Create open shifts for workspace2
        let workspace2 = workSpaces[1]
        let openShift1Workspace2 = Shift(location: workspace2.address, employee: nil, startTime: dateFormatter.date(from: "2023-08-10 09:00")!, endTime: dateFormatter.date(from: "2023-08-10 17:00")!)
        let openShift2Workspace2 = Shift(location: workspace2.address, employee: nil, startTime: dateFormatter.date(from: "2023-08-11 09:00")!, endTime: dateFormatter.date(from: "2023-08-11 17:00")!)
        
        workspace2.openShifts.append(contentsOf: [openShift1Workspace2, openShift2Workspace2])
    }
    
    static func createEmployeeShifts()
    {
        // Create shifts for each employee
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let shift1Employee1 = Shift(location: workspace1.address, employee: employee1, startTime: dateFormatter.date(from: "2023-08-01 09:00")!, endTime: dateFormatter.date(from: "2023-08-01 17:00")!)
        let shift2Employee1 = Shift(location: workspace1.address, employee: employee1, startTime: dateFormatter.date(from: "2023-08-02 09:00")!, endTime: dateFormatter.date(from: "2023-08-02 17:00")!)
        let shift3Employee1 = Shift(location: workspace2.address, employee: employee1, startTime: dateFormatter.date(from: "2023-08-05 09:00")!, endTime: dateFormatter.date(from: "2023-08-05 17:00")!)
        let shift4Employee1 = Shift(location: workspace2.address, employee: employee1, startTime: dateFormatter.date(from: "2023-08-06 09:00")!, endTime: dateFormatter.date(from: "2023-08-06 17:00")!)
        
        let shift1Employee2 = Shift(location: workspace1.address, employee: employee2, startTime: dateFormatter.date(from: "2023-08-01 10:00")!, endTime: dateFormatter.date(from: "2023-08-01 18:00")!)
        let shift2Employee2 = Shift(location: workspace1.address, employee: employee2, startTime: dateFormatter.date(from: "2023-08-02 10:00")!, endTime: dateFormatter.date(from: "2023-08-02 18:00")!)
        let shift3Employee2 = Shift(location: workspace2.address, employee: employee2, startTime: dateFormatter.date(from: "2023-08-05 10:00")!, endTime: dateFormatter.date(from: "2023-08-05 18:00")!)
        let shift4Employee2 = Shift(location: workspace2.address, employee: employee2, startTime: dateFormatter.date(from: "2023-08-06 10:00")!, endTime: dateFormatter.date(from: "2023-08-06 18:00")!)
        
        let shift1Employee3 = Shift(location: workspace2.address, employee: employee3, startTime: dateFormatter.date(from: "2023-08-03 08:30")!, endTime: dateFormatter.date(from: "2023-08-03 16:30")!)
        let shift2Employee3 = Shift(location: workspace2.address, employee: employee3, startTime: dateFormatter.date(from: "2023-08-04 08:30")!, endTime: dateFormatter.date(from: "2023-08-04 16:30")!)
        
        let shift1Employee4 = Shift(location: workspace2.address, employee: employee4, startTime: dateFormatter.date(from: "2023-08-03 09:30")!, endTime: dateFormatter.date(from: "2023-08-03 17:30")!)
        let shift2Employee4 = Shift(location: workspace2.address, employee: employee4, startTime: dateFormatter.date(from: "2023-08-04 09:30")!, endTime: dateFormatter.date(from: "2023-08-04 17:30")!)
        
        // Add shifts to each employee
        employee1.shifts.append(contentsOf: [(workspace1, shift1Employee1),(workspace1, shift2Employee1),(workspace2, shift3Employee1), (workspace2, shift4Employee1)])
        employee2.shifts.append(contentsOf: [(workspace1, shift1Employee2), (workspace1, shift2Employee2)])
        employee3.shifts.append(contentsOf: [(workspace2, shift1Employee3), (workspace2, shift2Employee3), (workspace2, shift3Employee2), (workspace2, shift4Employee2)])
        employee4.shifts.append(contentsOf: [(workspace2, shift1Employee4), (workspace2, shift2Employee4)])
    }
    
   
    static func addUserAvailability() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        for (index, user) in DataProvider.users.enumerated() {
            // Create shifts for availability in workspace1
            let shift1UserWorkspace1 = Shift(location: workspace1.address, employee: user, startTime: dateFormatter.date(from: "2023-08-01 09:00")!, endTime: dateFormatter.date(from: "2023-08-01 17:00")!)
            let shift2UserWorkspace1 = Shift(location: workspace1.address, employee: user, startTime: dateFormatter.date(from: "2023-08-02 09:00")!, endTime: dateFormatter.date(from: "2023-08-02 17:00")!)
            let shift3UserWorkspace1 = Shift(location: workspace1.address, employee: user, startTime: dateFormatter.date(from: "2023-08-05 09:00")!, endTime: dateFormatter.date(from: "2023-08-05 17:00")!)
            let shift4UserWorkspace1 = Shift(location: workspace1.address, employee: user, startTime: dateFormatter.date(from: "2023-08-06 09:00")!, endTime: dateFormatter.date(from: "2023-08-06 17:00")!)
            let shift5UserWorkspace1 = Shift(location: workspace1.address, employee: user, startTime: dateFormatter.date(from: "2023-08-03 09:00")!, endTime: dateFormatter.date(from: "2023-08-03 17:00")!)

            // Add shifts to availability for workspace1
            user.availability.append(contentsOf: [(workspace1, shift1UserWorkspace1), (workspace1, shift2UserWorkspace1), (workspace1, shift3UserWorkspace1), (workspace1, shift4UserWorkspace1), (workspace1, shift5UserWorkspace1)])

            if index >= 2 {
                // Create shifts for availability in workspace2
                let shift1UserWorkspace2 = Shift(location: workspace2.address, employee: user, startTime: dateFormatter.date(from: "2023-08-01 09:00")!, endTime: dateFormatter.date(from: "2023-08-01 17:00")!)
                let shift2UserWorkspace2 = Shift(location: workspace2.address, employee: user, startTime: dateFormatter.date(from: "2023-08-02 09:00")!, endTime: dateFormatter.date(from: "2023-08-02 17:00")!)
                let shift3UserWorkspace2 = Shift(location: workspace2.address, employee: user, startTime: dateFormatter.date(from: "2023-08-05 09:00")!, endTime: dateFormatter.date(from: "2023-08-05 17:00")!)
                let shift4UserWorkspace2 = Shift(location: workspace2.address, employee: user, startTime: dateFormatter.date(from: "2023-08-06 09:00")!, endTime: dateFormatter.date(from: "2023-08-06 17:00")!)
                let shift5UserWorkspace2 = Shift(location: workspace2.address, employee: user, startTime: dateFormatter.date(from: "2023-08-03 09:00")!, endTime: dateFormatter.date(from: "2023-08-03 17:00")!)

                // Add shifts to availability for workspace2
                user.availability.append(contentsOf: [(workspace2, shift1UserWorkspace2), (workspace2, shift2UserWorkspace2), (workspace2, shift3UserWorkspace2), (workspace2, shift4UserWorkspace2), (workspace2, shift5UserWorkspace2)])
            }
        }
    }
}
