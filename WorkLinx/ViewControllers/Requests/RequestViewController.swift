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
    
    private var requestTable: UITableView!
    private var infoMessageView: UIView? // Info message view
    private var requestsData = Utils.getTimeOffData()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Add nav bar
        requestTable = UITableView()
                
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
            buttonsStack.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 20),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            button1.widthAnchor.constraint(equalTo: button2.widthAnchor),
            button1.widthAnchor.constraint(equalTo: button3.widthAnchor),
            button1.heightAnchor.constraint(equalToConstant: 40),
            button2.heightAnchor.constraint(equalToConstant: 40),
            button3.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        buttonGroup = ButtonGroup(buttons: [button1, button2, button3], targetViewController: self)
        
        
        if requestsData.isEmpty {
            // Setup the info message view initially
            setupInfoMessageView()
        } else {
            view.addSubview(requestTable)
            NSLayoutConstraint.activate([
                requestTable.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 100),
                requestTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                requestTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                requestTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonTapped() {
        Utils.navigate(AddRequestViewController(tab: tab), self)
    }
    
    @objc func allRequestsButtonTapped() {
        tab = "All Requests"
        setupInfoMessageView()
    }
    
    @objc func timeOffButtonTapped() {
        tab = "Time Off"
        setupInfoMessageView()
    }
    
    @objc func reimbursementButtonTapped() {
        tab = "Reimbursement"
        setupInfoMessageView()
    }
    
    // Function to update the info message view based on data availability
    func setupInfoMessageView() {
        if  requestsData.isEmpty {
            if infoMessageView == nil {
                // Create the info message view
                let infoMessageView = EmptyListMessageView(message: "No \(tab == "Reimbursement" ? "Reimbursement" : (tab == "Time Off" ? "Time Off" : "")) requests added.\nTap + to add a request.")
                
                infoMessageView.arrowImageView.removeFromSuperview()
                view.addSubview(infoMessageView)

                NSLayoutConstraint.activate([
                    infoMessageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
                    infoMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    infoMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    infoMessageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
                ])
            }
            requestTable.separatorStyle = .none
        } else {
            infoMessageView?.removeFromSuperview()
            infoMessageView = nil
            requestTable.separatorStyle = .singleLine
        }
    }
}
