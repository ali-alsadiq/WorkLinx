//
//  AttendanceViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-08.
//

import UIKit

class AttendanceViewController: MenuBarViewController {
    override var userRole: UserRole {
            return .admin
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Attendance")
    }
}
