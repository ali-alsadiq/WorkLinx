//
//  UserDetailsViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-07.
//

import Foundation
import UIKit

class UserDetailsViewController: UIViewController {
    
    public var user: User
    private var navigationBar: CustomNavigationBar!
    private var positionLabel: UILabel!
    private var payRateLabel: UILabel!
    
    public var currentAvailabilty: Availability!
    
    let payRateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add pay rate"
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var position: String {
        get {
            if let index = Utils.workspace.employees.firstIndex(where: { $0.employeeId == user.id }) {
                return Utils.workspace.employees[index].position
            }
            return ""
        }
        set {
            if let index = Utils.workspace.employees.firstIndex(where: { $0.employeeId == user.id }) {
                Utils.workspace.employees[index].position = newValue
                Workspace.updateWorkspace(workspace: Utils.workspace) { _ in }
                positionLabel.text = newValue
            }
        }
    }
    
    var payRate: Double {
        get {
            if let index = Utils.workspace.employees.firstIndex(where: { $0.employeeId == user.id }) {
                return Utils.workspace.employees[index].payrate
            }
            return 0
        }
        set {
            if let index = Utils.workspace.employees.firstIndex(where: { $0.employeeId == user.id }) {
                Utils.workspace.employees[index].payrate = newValue
                Workspace.updateWorkspace(workspace: Utils.workspace) { _ in }
                payRateLabel.text = String(newValue)
            }
        }
    }
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        // Add nav bar
        navigationBar = CustomNavigationBar(title: "User Info")
        let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        
        navigationBar.items?.first?.leftBarButtonItem = backButton
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Create and configure header labels
        let firstNameHeader = createHeaderLabel(text: "First Name")
        let lastNameHeader = createHeaderLabel(text: "Last Name")
        let emailAddressHeader = createHeaderLabel(text: "Email Address")
        let addressHeader = createHeaderLabel(text: "Address")
        let positionHeader = createHeaderLabel(text: "Position")
        let payRateHeader = createHeaderLabel(text: "Pay rate")
        let availaibiltyHeader = createHeaderLabel(text: "Availabilty")
        
        // Create and configure value labels
        let firstNameLabel = createLabel(text: user.firstName, font: UIFont.systemFont(ofSize: 16, weight: .medium))
        let lastNameLabel = createLabel(text: user.lastName, font: UIFont.systemFont(ofSize: 16, weight: .medium))
        let emailAddressLabel = createLabel(text: user.emailAddress, font: UIFont.systemFont(ofSize: 16, weight: .medium))
        let addressLabel = createLabel(text: user.address, font: UIFont.systemFont(ofSize: 16))
        positionLabel = createLabel(text: position.isEmpty ? "No position set" : position, font: UIFont.systemFont(ofSize: 16))
        
        // Add header labels and value labels to the view
        let positionStack =  createStackView(headerLabel: positionHeader, valueLabel: positionLabel)
        positionStack.isUserInteractionEnabled = Utils.isAdmin
        positionStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(positionLabelTapped)))
        
        
        payRateTextField.text = payRateTextField.text != "0" ? String(payRate) : nil
        let payRateStack =  createStackView(headerLabel: payRateHeader, payRateTextField: payRateTextField)
        payRateStack.isUserInteractionEnabled = Utils.isAdmin
        payRateStack.isHidden = !Utils.isAdmin && user != Utils.user

        // Create an availability stack view
        let availabilityStackView = UIStackView()
        availabilityStackView.axis = .vertical
        availabilityStackView.spacing = 8
        availabilityStackView.alignment = .leading
        availabilityStackView.layer.borderWidth = 1
        availabilityStackView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        availabilityStackView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        availabilityStackView.layer.cornerRadius = 8
        availabilityStackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        availabilityStackView.isLayoutMarginsRelativeArrangement = true

        availabilityStackView.addArrangedSubview(availaibiltyHeader)

        if let currentAvailabilty = currentAvailabilty {
            for availableDay in currentAvailabilty.availableDays {
                var availabilityText = ""
                var availabilityTextColor = UIColor.black // Default color
                
                if availableDay.isAvailable {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "h:mm a"
                    
                    let startTimeString = dateFormatter.string(from: availableDay.startTime)
                    let endTimeString = dateFormatter.string(from: availableDay.endTime)
                    
                    availabilityText = "\(startTimeString) - \(endTimeString)"
                    availabilityTextColor = UIColor.blue
                } else if availableDay.isSet {
                    availabilityText = "Not Available"
                    availabilityTextColor = Utils.darkRed
                } else {
                    availabilityText = "Not Set"
                    availabilityTextColor = Utils.darkOrange
                }
                
                let dayLabel = createLabel(
                    text: availableDay.day,
                    font: UIFont.systemFont(ofSize: 16, weight: .bold)
                )
                dayLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
                
                let availabilityTimeLabel = UILabel()
                availabilityTimeLabel.text = availabilityText
                availabilityTimeLabel.font = UIFont.systemFont(ofSize: 16)
                availabilityTimeLabel.textColor = availabilityTextColor
                
                let availabilityRowStack = UIStackView()
                availabilityRowStack.axis = .horizontal
                availabilityRowStack.spacing = 8
                
                availabilityRowStack.addArrangedSubview(dayLabel)
                availabilityRowStack.addArrangedSubview(availabilityTimeLabel)
                
                availabilityStackView.addArrangedSubview(availabilityRowStack)
            }
        } else {
            // Add an availability header with "Availability Not Set" text
            let availabilityHeaderLabel = createHeaderLabel(text: "Availability")
            let availabilityNotSetText = "Availability Not Set"
            let availabilityNotSetLabel = createLabel(text: availabilityNotSetText, font: UIFont.systemFont(ofSize: 16))
            availabilityStackView.addArrangedSubview(availaibiltyHeader)
            availabilityStackView.addArrangedSubview(availabilityNotSetLabel)
        }
        
        let stackView = UIStackView(arrangedSubviews: [
            createStackView(headerLabel: firstNameHeader, valueLabel: firstNameLabel),
            createStackView(headerLabel: lastNameHeader, valueLabel: lastNameLabel),
            createStackView(headerLabel: emailAddressHeader, valueLabel: emailAddressLabel),
            createStackView(headerLabel: addressHeader, valueLabel: addressLabel),
            positionStack,
            payRateStack,
            availabilityStackView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        view.addSubview(stackView)
        
        // Add constraints to position the stack view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
           
            payRateTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -50)
        ])
    }
    
    private func createStackView(headerLabel: UILabel,
                                 valueLabel: UILabel? = nil,
                                 payRateTextField: UITextField? = nil) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.addArrangedSubview(headerLabel)
        if valueLabel != nil {
            stackView.addArrangedSubview(valueLabel!)
        } else {
            stackView.addArrangedSubview(payRateTextField!)
        }
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.layer.borderWidth = 1
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        stackView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        stackView.layer.cornerRadius = 8
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }
    
    private func createLabel(text: String, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        return label
    }
    
    private func createHeaderLabel(text: String) -> UILabel {
        let headerLabel = createLabel(text: text, font: UIFont.systemFont(ofSize: 12, weight: .medium))
        headerLabel.textAlignment = .right
        headerLabel.textColor = .gray
        return headerLabel
    }
    
    private func createStyledLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.white
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.cornerRadius = 10.0
        label.layer.opacity = 1.0
        return label
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        
        // update payrate in DB here
        if let index = Utils.workspace.employees.firstIndex(where: { $0.employeeId == user.id }) {
            // Update the employee information at the found index
            var updatedEmployeeInfo =  Utils.workspace.employees[index]
            updatedEmployeeInfo.payrate =  Double(payRateTextField.text!)!
            print(updatedEmployeeInfo)
            
            Utils.workspace.employees[index] = updatedEmployeeInfo
            Workspace.updateWorkspace(workspace: Utils.workspace) { [unowned self] _ in
                print(Utils.workspace)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc private func positionLabelTapped() {
        let positionVC = PositionsViewController()
        positionVC.userDetailVC = self
        Utils.navigate(positionVC, self)
    }
    
}
