//
//  AvailabilityViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-08.
//

import UIKit
import SwiftUI

class AvailabilityViewController: UIViewController {
    
    private var navigationBar: CustomNavigationBar!
    private var saveButton: BackButton!
    private var taggedDatesArr: [TaggedDate] = []
    private var availabiltyScrollView: UIScrollView!
    private var availabiltyStackView: UIStackView!

    public var currentAvailabilty: Availability?

    private let days = [
        ("Monday", 1),
        ("Tuesday", 2),
        ("Wednesday", 3),
        ("Thursday", 4),
        ("Friday", 5),
        ("Saturday", 6),
        ("Sunday", 7)
    ]

    private var availabilityText = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationBar = CustomNavigationBar(title: "Availability")
        let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        saveButton = BackButton(text: "Save", target: self, action: #selector(saveButtonTapped))
    
        navigationBar.items?.first?.leftBarButtonItem = backButton
        navigationBar.items?.first?.rightBarButtonItem = saveButton
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        availabiltyScrollView = UIScrollView()
        availabiltyScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(availabiltyScrollView)

        availabiltyStackView = UIStackView()
        availabiltyStackView.axis = .vertical
        availabiltyStackView.spacing = 20
        availabiltyStackView.translatesAutoresizingMaskIntoConstraints = false
        availabiltyScrollView.addSubview(availabiltyStackView)

        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            availabiltyScrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 20),
            availabiltyScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            availabiltyScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            availabiltyScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            availabiltyStackView.topAnchor.constraint(equalTo: availabiltyScrollView.topAnchor, constant: 20),
            availabiltyStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            availabiltyStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            availabiltyStackView.bottomAnchor.constraint(equalTo: availabiltyScrollView.bottomAnchor),
        ])

        for day in days {
            let dayLabel = UILabel()
            dayLabel.text = day.0
            dayLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            
            let dayButtonsStack = createStackWithButtonsAndTimePicker(
                title1: "Available",
                tag1: day.1,
                title2: "Not Available",
                tag2: -day.1,
                day: day,
                target: self,
                action: #selector(availabilityButtonTapped(_:))
            )
            
            let dayStackView = UIStackView(arrangedSubviews: [dayLabel, dayButtonsStack])
            dayStackView.axis = .vertical
            dayStackView.spacing = 8
            
            availabiltyStackView.addArrangedSubview(dayStackView)
        }
        
        updateUIBasedOnAvailability()
    }
    
    func createButton(title: String, tag: Int, target: Any?, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.tag = tag
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.gray.cgColor
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        return button
    }


    func createButtonsStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    func createStackWithButtons(title1: String, tag1: Int,
                                title2: String, tag2: Int,
                                target: Any?, action: Selector) -> UIStackView {
        let button1 = createButton(title: title1, tag: tag1, target: target, action: action)
        let button2 = createButton(title: title2, tag: tag2, target: target, action: action)
        return createButtonsStackView(arrangedSubviews: [button1, button2])
    }

    func createTimePickerHostingController(selectedTime: Binding<Date>, timeTitle: String) -> UIHostingController<TimePickerView> {
        let timePicker = TimePickerView(selectedTime: selectedTime
                                        , time: timeTitle)
        let hostingController = UIHostingController(rootView: timePicker)
        return hostingController
    }
    
    func createStackWithButtonsAndTimePicker(title1: String, tag1: Int, title2: String, tag2: Int,day: (String, Int), target: Any?, action: Selector) -> UIStackView {
        
        let buttonsStackView = createStackWithButtons(title1: title1, tag1: tag1, title2: title2, tag2: tag2, target: target, action: action)
        
        let selectedStartTime = TaggedDate(date: Date(), tag: tag1 * 10 + 1)
        let selectedEndTime = TaggedDate(date: Date(), tag: tag2 * 10 - 1)
        
        taggedDatesArr.append(contentsOf: [selectedStartTime, selectedEndTime])
        
        var selectedStartTimeBinding: Binding<Date> {
            Binding<Date>(
                get: { selectedStartTime.date },
                set: { selectedStartTime.date = $0 }
            )
        }
        
        var selectedEndTimeBinding: Binding<Date> {
            Binding<Date>(
                get: { selectedEndTime.date },
                set: { selectedEndTime.date = $0 }
            )
        }
        
        selectedStartTime.date = Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: selectedStartTime.date) ?? selectedStartTime.date
        let startTimePicker = createTimePickerHostingController(selectedTime: selectedStartTimeBinding, timeTitle: "Start Time")
        
        selectedEndTime.date = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: selectedEndTime.date) ?? selectedEndTime.date
        let endTimePicker = createTimePickerHostingController(selectedTime: selectedEndTimeBinding, timeTitle: "End Time")
        
        startTimePicker.view.translatesAutoresizingMaskIntoConstraints = false
        endTimePicker.view.translatesAutoresizingMaskIntoConstraints = false

        let timePickersStackView = UIStackView(arrangedSubviews: [startTimePicker.view, endTimePicker.view])
        timePickersStackView.axis = .vertical
        timePickersStackView.spacing = 8
        timePickersStackView.translatesAutoresizingMaskIntoConstraints = false
        
        timePickersStackView.tag = tag1 * 100
        
        // update selected time if it's set
        if let availabilityForDay = currentAvailabilty?.availableDays.first(where: { $0.day == day.0 }) {
            selectedStartTime.date = availabilityForDay.startTime
            selectedEndTime.date = availabilityForDay.endTime
        }
        
        // hide all times if there is an availabilty with user id in work space
        timePickersStackView.isHidden = true

        let stackView = UIStackView(arrangedSubviews: [buttonsStackView, timePickersStackView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    @objc func availabilityButtonTapped(_ button: UIButton) {
        let selectedTag = button.tag
        let notSelectedTag = -selectedTag
        
        // Find the button with the selected tag and change its color
        if let selectedButton = view.viewWithTag(selectedTag) as? UIButton {
            selectedButton.backgroundColor = selectedTag > 0 ? .systemBlue : .systemRed
            selectedButton.setTitleColor(.white, for: .normal)

            selectedButton.isEnabled = false
            
            let timePickerStackTag = selectedTag * 100
            if let timePickerStack = view.viewWithTag(timePickerStackTag) as? UIStackView {
                timePickerStack.isHidden = false
            }
        }
        
        // Find the "Not Available" button with the negative tag and change its color
        if let notAvailableButton = view.viewWithTag(notSelectedTag) as? UIButton {
            notAvailableButton.backgroundColor = .white
            notAvailableButton.setTitleColor(.darkGray, for: .normal)

            notAvailableButton.isEnabled = true
            
            let timePickerStackTag = notSelectedTag * 100
            if let timePickerStack = view.viewWithTag(timePickerStackTag) as? UIStackView {
                timePickerStack.isHidden = true
            }
        }
    }
    
    @objc func saveButtonTapped() {
        
        var avaialabity = Availability(workSpaceId: Utils.workspace.workspaceId,
                                       userId: Utils.user.id,
                                       availableDays: [])
        var didSetAvailabitly = false
        
        for day in days {
            let availableTag = day.1
            let availableButton = view.viewWithTag(availableTag) as? UIButton
            let notAvailableButton = view.viewWithTag(-availableTag) as? UIButton
            
            let startTimePickerTag = availableTag * 10 + 1
            let endTimePickerTag = -availableTag * 10 - 1
            
            let startTimePicker = taggedDatesArr.first(where: { $0.tag == startTimePickerTag })
            let endTimePicker = taggedDatesArr.first(where: { $0.tag == endTimePickerTag })
            
            let startTime = startTimePicker?.date ?? Date()
            let endTime = endTimePicker?.date ?? Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            
            let startTimeString = dateFormatter.string(from: startTime)
            let endTimeString = dateFormatter.string(from: endTime)
            
            if let isSelected = availableButton?.isEnabled, !isSelected {
                didSetAvailabitly = true
                // user is availabe
                avaialabity.availableDays.append(Availability.AvailableDay(day: day.0, startTime: startTime, endTime:endTime, isSet: true, isAvailable: true))
                
                availabilityText += "\(day.0): \(startTimeString) - \(endTimeString)\n"
            } else if let isSelected = notAvailableButton?.isEnabled, !isSelected {
                didSetAvailabitly = true
                //user is not available
                avaialabity.availableDays.append(Availability.AvailableDay(day: day.0, startTime: startTime, endTime:endTime, isSet: true, isAvailable: false))
            }
            
            else {
                //user did not set
                avaialabity.availableDays.append(Availability.AvailableDay(day: day.0, startTime: startTime, endTime:endTime, isSet: false, isAvailable: false))
            }
        }
        
        if didSetAvailabitly && currentAvailabilty == nil {
            // create a new availabilty
            avaialabity.createAvailabilty() { result in
                switch result {
                case .success(let availabiltyId):
                    Utils.user.availabilityIds.append(availabiltyId)
                    Utils.user.setUserData { _ in }
                case .failure(let error):
                    print("Error creating availabilty: \(error.localizedDescription)")
                }
            }
        } else if currentAvailabilty != nil {
            // update exisiting
            avaialabity.id = currentAvailabilty!.id
            avaialabity.setAvailabiltyData { _ in }
        }
        
        goBack()
    }
    
    
    @objc func goBack() {
        dismiss(animated: true)
    }

    func updateUIBasedOnAvailability() {
        for day in days {
            if let availabilityForDay = currentAvailabilty?.availableDays.first(where: { $0.day == day.0 }) {
                // Update button appearance based on availability data
                let selectedButtonTag = availabilityForDay.isAvailable ? day.1 : -day.1
                
                if let selectedButton = view.viewWithTag(selectedButtonTag) as? UIButton, availabilityForDay.isSet {
                    availabilityButtonTapped(selectedButton)
                }
            }
        }
    }
}

class TaggedDate {
    var date: Date
    let tag: Int
    
    init(date: Date, tag: Int) {
        self.date = date
        self.tag = tag
    }
}
