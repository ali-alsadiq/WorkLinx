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
    var shiftsListManger = ShiftsListManager()
    
    var shifts: [Shift] = []
    var calenderListView: CalendarListView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = Utils.isAdmin ? "Scheduler" : "Schedule"

        
        if isGoingBack {
            let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
            navigationItem.leftBarButtonItem = backButton
            menuBarStack.removeFromSuperview()
        }
        
        if Utils.isAdmin {
            let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
            plusButton.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 22)], for: .normal)
            navigationItem.rightBarButtonItem = plusButton
        }
      
        
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
            buttonsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            button1.widthAnchor.constraint(equalTo: button2.widthAnchor),
            button1.widthAnchor.constraint(equalTo: button3.widthAnchor),
            button1.heightAnchor.constraint(equalToConstant: 40),
            button2.heightAnchor.constraint(equalToConstant: 40),
            button3.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        buttonGroup = ButtonGroup(buttons: [button1, button2, button3], targetViewController: self)

        calenderListView = CalendarListView(selectedDateManager: selectedDateManager, shiftsListManger: shiftsListManger)
        let hostingController = UIHostingController(rootView: calenderListView)
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
        let addShiftView = AddShiftViewController(selectedDate: selectedDateManager.selectedDate)
        addShiftView.shiftsListManger = calenderListView.shiftsListManger
        Utils.navigate(addShiftView, self)
    }
    
    @objc func allShiftsButtonTapped() {
        if Utils.isAdmin {
            shiftsListManger.shifts = Utils.workspaceOpenShifts + Utils.workspaceAssignedShifts
        } else {
            shiftsListManger.shifts = Utils.workspaceOpenShifts + Utils.currentUserShifts
        }
    }
    
    @objc func shiftsButtonTapped() {
        if Utils.isAdmin {
            shiftsListManger.shifts = Utils.workspaceAssignedShifts
        } else {
            shiftsListManger.shifts = Utils.currentUserShifts
        }
    }
    
    @objc func openShiftsButtonTapped() {
        shiftsListManger.shifts = Utils.workspaceOpenShifts
    }
}


