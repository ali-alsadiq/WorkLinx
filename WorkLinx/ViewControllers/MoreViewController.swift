//
//  MoreViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-08.
//

import UIKit

class MoreViewController : MenuBarViewController {
    override var userRole: UserRole {
            return .employee
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Dashboard")
    }
}
