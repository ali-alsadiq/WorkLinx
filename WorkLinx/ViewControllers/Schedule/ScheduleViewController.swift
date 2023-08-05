//
//  ScheduleViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-08.
//

import UIKit
import SwiftUI

class ScheduleViewController: MenuBarViewController {
    
    var buttonGroup: ButtonGroup!
    var isGoingBack = false
    var tab = ""
    
    var selectedDateManager = SelectedDateManager()
    
    var events: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let navigationBar = CustomNavigationBar(title: Utils.isAdmin ? "Scheduler" : "Schedule")
        
        if isGoingBack {
            let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
            navigationBar.items?.first?.leftBarButtonItem = backButton
            menuBarStack.removeFromSuperview()
        }
        
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        plusButton.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 22)], for: .normal)
        navigationBar.items?.first?.rightBarButtonItem = plusButton
        
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let button1 = Utils.createButton(withTitle: "All Shifts")
        let button2 = Utils.createButton(withTitle: "Shifts")
        let button3 = Utils.createButton(withTitle: "Open Shifts")
        
        // Set the initial state
        switch tab
        {
        case "My Shifts":
            shiftsButtonTapped()
            button2.isSelected = true
        case "Open Shifts":
            openShiftsButtonTapped()
            button3.isSelected = true
        default :
            allShiftsButtonTapped()
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

        
        let hostingController = UIHostingController(rootView: CalendarListView(selectedDateManager: selectedDateManager, events: events))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: 20),
            hostingController.view.bottomAnchor.constraint(equalTo: isGoingBack ? view.bottomAnchor : menuBarStack.topAnchor)
        ])
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonTapped() {
        Utils.navigate(AddShiftViewController(selectedDate: selectedDateManager.selectedDate), self)
    }
    
    @objc func allShiftsButtonTapped() {
        print("All shifts button was tapped.")
        // Implement your custom action for the Time Off button here
    }
    
    @objc func shiftsButtonTapped() {
        print("Shifts button was tapped.")
        // Implement your custom action for the Shifts button here
    }
    
    @objc func openShiftsButtonTapped() {
        print("OpenShifts button was tapped.")
        // Implement your custom action for the OpenShifts button here
    }
}


