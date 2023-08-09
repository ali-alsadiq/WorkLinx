//
//  EditTimeOffViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-09.
//

import Foundation
import UIKit

class EditTimeOffViewController: UIViewController {
    
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
        
        view.backgroundColor = .white
        
        let navigationBar = CustomNavigationBar(title: "Edit Time Off")
        let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        navigationBar.items?.first?.leftBarButtonItem = backButton
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        
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
        
        
        if Utils.isAdmin {
            let approveButton = createButton(title: "Approve",
                                             target: self,
                                             action: #selector(goBack),
                                             color: UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
)
            
            let rejectButton = createButton(title: "Reject",
                                            target: self,
                                            action: #selector(goBack),
                                            color: UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0))
            
            // Add form elements to a stack
            let buttonsStack = UIStackView(arrangedSubviews: [approveButton, rejectButton])
            buttonsStack.axis = .horizontal
            buttonsStack.spacing = 20
            buttonsStack.distribution = .fillEqually
            buttonsStack.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(buttonsStack)
            
            NSLayoutConstraint.activate([
                buttonsStack.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
                buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                buttonsStack.heightAnchor.constraint(equalToConstant: 45)
            ])
        } else {
            // user view own request, add button to cancel and
            // implement logic to remove from db and Utils.workSpceTimeOffs
        }
        
    }
    
    private func createStackView(headerLabel: UILabel, valueLabel: UILabel) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [headerLabel, valueLabel])
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
    
    
    func createButton(title: String, target: Any?, action: Selector, color: UIColor) -> UIButton{
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = color.cgColor
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        return button
    }
    
    private func createHeaderLabel(text: String) -> UILabel {
        let headerLabel = createLabel(text: text, font: UIFont.systemFont(ofSize: 12, weight: .medium))
        headerLabel.textAlignment = .right
        headerLabel.textColor = .gray
        return headerLabel
    }
    
    
    private func createLabel(text: String, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        return label
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
}
