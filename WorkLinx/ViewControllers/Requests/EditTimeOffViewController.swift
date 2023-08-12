//
//  EditTimeOffViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-09.
//

import Foundation
import UIKit

class EditTimeOffViewController: EditRequestViewController {
    
    private var user: User
    private var timeOff: TimeOff
    private var requestStack: UIStackView!
    
    
    init(user: User, timeOff: TimeOff) {
        self.user = user
        self.timeOff = timeOff
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userNameHeader = createHeaderLabel(text: "User Name")
        let startDateHeader = createHeaderLabel(text: "Start Date")
        let endDateHeader = createHeaderLabel(text: "End Date")
        let statusHeader = createHeaderLabel(text: "Status")
        
        // Create and configure value labels
        let userNameLabel = createLabel(text: "\(user.firstName) \(user.lastName) ",
                                        font: UIFont.systemFont(ofSize: 16, weight: .medium))
        
        let startDateLabel = createLabel(text: "\(Utils.formattedDateWithDayName(timeOff.startTime))",
                                         font: UIFont.systemFont(ofSize: 16, weight: .medium))
        
        let endDateLabel = createLabel(text: "\(Utils.formattedDateWithDayName(timeOff.endTime))",
                                       font: UIFont.systemFont(ofSize: 16, weight: .medium))
        
        let statusLabel = createLabel(text: "\(timeOff.status)",
                                      font: UIFont.systemFont(ofSize: 16))
        
        statusLabel.textColor = timeOff.status == "Pending" ? Utils.darkOrange
        : timeOff.status == "Rejected" ? Utils.darkRed
        : Utils.darkGreen
        
        
        requestStack = UIStackView()
        
        requestStack = UIStackView(
            arrangedSubviews: [
                createStackView(headerLabel: userNameHeader, valueLabel: userNameLabel),
                createStackView(headerLabel: startDateHeader, valueLabel: startDateLabel),
                createStackView(headerLabel: endDateHeader, valueLabel: endDateLabel),
                createStackView(headerLabel: statusHeader, valueLabel: statusLabel)
            ])
        
        requestStack.axis = .vertical
        requestStack.spacing = 15
        
        view.addSubview(requestStack)
        
        // Add constraints to position the stack view
        requestStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            requestStack.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 25),
            requestStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            requestStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
