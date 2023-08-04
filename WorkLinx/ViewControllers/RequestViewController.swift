//
//  RequestViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-08.
//

import UIKit
import SwiftUI

class RequestViewController: MenuBarViewController {
    
    var buttonGroup: ButtonGroup!
    var isGoingBack = false
    var tab = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = CustomNavigationBar(title: "Requests")
        
        if isGoingBack {
            let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
            navigationBar.items?.first?.leftBarButtonItem = backButton
            menuBarStack.removeFromSuperview()
        }
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        plusButton.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], for: .normal)
        navigationBar.items?.first?.rightBarButtonItem = plusButton
        
        let button1 = Utils.createButton(withTitle: "All Requests")
        let button2 = Utils.createButton(withTitle: "Time Off")
        let button3 = Utils.createButton(withTitle: "Reimbursement")
        
        // Set the initial state
        switch tab
        {
        case "Time Off" :
            timeOffButtonTapped()
            button2.isSelected = true
        case "Reimbursement" :
            reimbursementButtonTapped()
            button3.isSelected = true
        default :
            allRequestsButtonTapped()
            button1.isSelected = true
        }
        
        let buttonsStack = UIStackView(arrangedSubviews: [button1, button2, button3])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 0
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            buttonsStack.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            button1.widthAnchor.constraint(equalTo: button2.widthAnchor),
            button1.widthAnchor.constraint(equalTo: button3.widthAnchor),
            button1.heightAnchor.constraint(equalToConstant: 40),
            button2.heightAnchor.constraint(equalToConstant: 40),
            button3.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        buttonGroup = ButtonGroup(buttons: [button1, button2, button3], targetViewController: self)
        
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonTapped() {
        // ... Your addButtonTapped code ...
    }
    
    @objc func allRequestsButtonTapped() {
        print("All Request button was tapped.")
        // Implement your custom action for the Time Off button here
    }
    
    @objc func timeOffButtonTapped() {
        print("Time off button was tapped.")
        // Implement your custom action for the Shifts button here
    }
    
    @objc func reimbursementButtonTapped() {
        print("Reimbursement button was tapped.")
        // Implement your custom action for the OpenShifts button here
    }
}
