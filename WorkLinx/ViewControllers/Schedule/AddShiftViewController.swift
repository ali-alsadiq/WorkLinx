//
//  AddShiftViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-04.
//

import UIKit
import SwiftUI

class AddShiftViewController: UIViewController {
    
    private var openShiftButton: UIButton!
    private var shiftButton: UIButton!
    private var saveButton: UIBarButtonItem!
    static var assignedUsers: [User] = []
    private var shiftType = "assigned"
    private var assignButton = UIButton()
    
    var selectedDate: Date
    var selectedStartTime: Date
    var selectedEndTime: Date
    
    @ObservedObject public var userManger = UsereManager(assignedUsers: AddShiftViewController.assignedUsers)
    var shiftsListManger: ShiftsListManager!
    
    private var assignedUsersList: UIHostingController<AssignedUserList>!
    private var compactDatePicker: UIHostingController<CompactDatePickerView>!
    private var startTimePicker: UIHostingController<TimePickerView>!
    private var endTimePicker: UIHostingController<TimePickerView>!
    

    
    private var selectedDateBinding: Binding<Date> {
        Binding<Date>(
            get: { self.selectedDate },
            set: { self.selectedDate = $0 }
        )
    }
    
    private var selectedStartTimeBinding: Binding<Date> {
        Binding<Date>(
            get: { self.selectedStartTime },
            set: { self.selectedStartTime = $0 }
        )
    }
    
    private var selectedEndTimeBinding: Binding<Date> {
        Binding<Date>(
            get: { self.selectedEndTime },
            set: { self.selectedEndTime = $0 }
        )
    }
    
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        self.selectedStartTime = selectedDate
        self.selectedEndTime = selectedDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
                
        let navigationBar = CustomNavigationBar(title: "Add Shift")
        
        let backButton = BackButton(text: "Cancel", target: self, action: #selector(goBack))
        navigationBar.items?.first?.leftBarButtonItem = backButton
        
        saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        navigationBar.items?.first?.rightBarButtonItem = saveButton
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        compactDatePicker = UIHostingController(
            rootView: CompactDatePickerView(selectedDate: selectedDateBinding, label: "Date")
        )
        
        selectedStartTime = Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: selectedStartTime) ?? selectedStartTime
        startTimePicker = UIHostingController(
            rootView: TimePickerView(selectedTime: selectedStartTimeBinding, time: "Start Time")
        )
        
        selectedEndTime = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: selectedEndTime) ?? selectedEndTime
        endTimePicker = UIHostingController(
            rootView: TimePickerView(selectedTime: selectedEndTimeBinding, time: "End Time")
        )
        
        addChild(compactDatePicker)
        addChild(startTimePicker)
        addChild(endTimePicker)
        
        view.addSubview(compactDatePicker.view)
        view.addSubview(startTimePicker.view)
        view.addSubview(endTimePicker.view)
        
        compactDatePicker.view.translatesAutoresizingMaskIntoConstraints = false
        startTimePicker.view.translatesAutoresizingMaskIntoConstraints = false
        endTimePicker.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            compactDatePicker.view.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 20),
            compactDatePicker.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            compactDatePicker.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            startTimePicker.view.topAnchor.constraint(equalTo: compactDatePicker.view.bottomAnchor, constant: 20),
            startTimePicker.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            startTimePicker.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            endTimePicker.view.topAnchor.constraint(equalTo: startTimePicker.view.bottomAnchor, constant: 20),
            endTimePicker.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            endTimePicker.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        compactDatePicker.didMove(toParent: self)
        startTimePicker.didMove(toParent: self)
        endTimePicker.didMove(toParent: self)
        
        
        openShiftButton = UIButton(type: .system)
        openShiftButton.setTitle("Open Shift", for: .normal)
        openShiftButton.addTarget(self, action: #selector(openShiftButtonTapped), for: .touchUpInside)
        openShiftButton.layer.borderWidth = 1.0
        openShiftButton.layer.borderColor = UIColor.gray.cgColor
        openShiftButton.setTitleColor(.darkGray, for: .normal)
        openShiftButton.backgroundColor = .white
        openShiftButton.layer.cornerRadius = 15
        openShiftButton.translatesAutoresizingMaskIntoConstraints = false
        openShiftButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        view.addSubview(openShiftButton)
        
        shiftButton = UIButton(type: .system)
        shiftButton.setTitle("Assign Shift", for: .normal)
        shiftButton.addTarget(self, action: #selector(assignShiftButtonTapped), for: .touchUpInside)
        shiftButton.layer.borderWidth = 1.0
        shiftButton.layer.borderColor = UIColor.gray.cgColor
        shiftButton.setTitleColor(.darkGray, for: .normal)
        shiftButton.backgroundColor = .white
        shiftButton.layer.cornerRadius = 15
        shiftButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        shiftButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shiftButton)
        
        // Add form elements to a stack
        let buttonsStack = UIStackView(arrangedSubviews: [openShiftButton, shiftButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 20
        buttonsStack.distribution = .fillEqually
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonsStack)
        
        assignShiftButtonTapped()
        
        NSLayoutConstraint.activate([
            buttonsStack.topAnchor.constraint(equalTo: endTimePicker.view.bottomAnchor, constant: 20),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStack.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        // Add Assign users button
        assignButton = UIButton()
        assignButton.setTitle("Assign Users", for: .normal)
        assignButton.addTarget(self, action: #selector(assignButtonTapped), for: .touchUpInside)
        assignButton.layer.borderWidth = 1.0
        assignButton.layer.borderColor = UIColor.gray.cgColor
        assignButton.setTitleColor(.white, for: .normal)
        assignButton.backgroundColor = .darkGray
        assignButton.layer.cornerRadius = 15
        assignButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        assignButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(assignButton)
        
        NSLayoutConstraint.activate([
            assignButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -85),
            assignButton.heightAnchor.constraint(equalToConstant: 55),
            assignButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            assignButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        assignedUsersList = UIHostingController(rootView: AssignedUserList(userManger: userManger,
                                                                               onRemove: { user in
            self.removeUser(user)
        }))
        
        addChild(assignedUsersList)
        assignedUsersList.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(assignedUsersList.view)

        NSLayoutConstraint.activate([
            assignedUsersList.view.topAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: 20),
            assignedUsersList.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            assignedUsersList.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            assignedUsersList.view.bottomAnchor.constraint(equalTo: assignButton.topAnchor, constant: -20)
        ])
        assignedUsersList.didMove(toParent: self)
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        if shiftType == "assigned" && AddShiftViewController.assignedUsers.count == 0 {
            Utils.showAlert(title: "No assigned employees", message: "You must add employees to create an asssigned shit!", viewController: self)
            return
        }
        let employeeIds = AddShiftViewController.assignedUsers.map { $0.id }
        
        print (AddShiftViewController.assignedUsers)
        let newShift = Shift(employeeIds: employeeIds,
                             workspaceId: Utils.workspace.workspaceId,
                             date: selectedDate,
                             startTime: selectedStartTime,
                             endTime: selectedEndTime)
        
        Shift.createShift(shift: newShift) { [weak self] result in
            switch result {
            case .success(let id):
                print("created shift with id: \(id)")
                for index in 0..<AddShiftViewController.assignedUsers.count {
                    AddShiftViewController.assignedUsers[index].shiftIds.append(id)
                    AddShiftViewController.assignedUsers[index].setUserData() {_ in
                        print("Shift added to user successfullt")
                    }
                }
                
                if AddShiftViewController.assignedUsers.count == 0 {
                    Utils.workspace.openShiftsIds.append(id)
                    Utils.workspaceOpenShifts.append(newShift)
                    self?.shiftsListManger.shifts.append(newShift)
                }
                else {
                    Utils.workspace.shiftIds.append(id)
                    Utils.workspaceAssignedShifts.append(newShift)
                    self?.shiftsListManger.shifts.append(newShift)
                }
                
                Workspace.updateWorkspace(workspace: Utils.workspace) {_ in
                    print("Shift added to user successfully")
                }
                self!.userManger.assignedUsers = []
                AddShiftViewController.assignedUsers = []
            case .failure(let error):
                // Error occurred while creating the workspace
                print("Error creating workspace: \(error.localizedDescription)")
            }
        }
        goBack()
    }
    
    @objc func openShiftButtonTapped() {
        shiftType = "open"
        assignButton.isHidden = true
        
        shiftButton.setTitleColor(.darkGray, for: .normal)
        shiftButton.backgroundColor = .white
        
        openShiftButton.setTitleColor(.white, for: .normal)
        openShiftButton.backgroundColor = .darkGray
        
    }
    
    @objc func assignShiftButtonTapped() {
        shiftType = "assigned"
        assignButton.isHidden = false

        shiftButton.setTitleColor(.white, for: .normal)
        shiftButton.backgroundColor = .darkGray
        
        openShiftButton.setTitleColor(.darkGray, for: .normal)
        openShiftButton.backgroundColor = .white
    }
    
    
    func removeUser(_ user: User) {
        AddShiftViewController.assignedUsers.removeAll(where: {$0.id == user.id})
        userManger.removeUser(user)
    }
    
    @objc func assignButtonTapped(){
        let assignVC = UsersTableViewController()
        assignVC.modalPresentationStyle = .formSheet
        assignVC.addShiftsView = self
        present(assignVC, animated: true, completion: nil)
    }
}
