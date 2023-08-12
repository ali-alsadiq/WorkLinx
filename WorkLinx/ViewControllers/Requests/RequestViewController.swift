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
    var tab = "" {
        didSet {
            requestListManger.tab = tab
        }
    }
    
    private var infoMessageView: EmptyListMessageView?
    
    private var requestsHostingController: UIHostingController<RequestsList>!
    
    @ObservedObject private var requestListManger = RequestListManger()
    
    override func viewWillAppear(_ animated: Bool) {
        requestsHostingController.view.isHidden = Utils.workspaceReimbursements.isEmpty && Utils.workSpceTimeOffs.isEmpty
        setupInfoMessageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestListManger.hostingVC = self
        
        view.backgroundColor = .white
        
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
        
        let requestsList = RequestsList(requestListManger: requestListManger)
        
        requestsHostingController = UIHostingController(rootView: requestsList)
        requestsHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(requestsHostingController.view)
        
        NSLayoutConstraint.activate([
            requestsHostingController.view.topAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: 20),
            requestsHostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            requestsHostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            requestsHostingController.view.bottomAnchor.constraint(equalTo: isGoingBack ? view.bottomAnchor : menuBarStack.topAnchor)
        ])
        
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
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonTapped() {
        let addRequestVC = AddRequestViewController(tab: tab, requestListManger: requestListManger, requestVC: self)
        Utils.navigate(addRequestVC, self)
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
        let isReimbursementTab = tab == "Reimbursement"
        let isTimeOffTab = tab == "Time Off"
        let isAllRequestsTab = tab == "All Requests"
        
        let isEmptyReimbursements = Utils.isAdmin
                                            ? Utils.notModifiedByAdminReimbursements.isEmpty
                                            : Utils.workspaceReimbursements.filter{ Utils.user.id == $0.userId}.isEmpty

        let isEmptyTimeOffs =  Utils.isAdmin
                                        ? Utils.notModifiedByAdmiTimeOffs.isEmpty
                                        : Utils.workSpceTimeOffs.filter{ Utils.user.id == $0.userId}.isEmpty

        if (isReimbursementTab && isEmptyReimbursements) ||
            (isTimeOffTab && isEmptyTimeOffs) ||
            (isAllRequestsTab && isEmptyReimbursements && isEmptyTimeOffs) {
            
            // Create the info message view
            let message = "No \(isReimbursementTab ? "Reimbursement" : isTimeOffTab ? "Time Off" : "") requests added.\nTap + to add a request."
            
            // Remove from view before adding a new one
            if infoMessageView != nil {
                infoMessageView!.removeFromSuperview()
            }
            
            infoMessageView = EmptyListMessageView(message: message)
            
            infoMessageView!.arrowImageView.removeFromSuperview()
            
            infoMessageView!.isHidden = false

            view.addSubview(infoMessageView!)
            
            NSLayoutConstraint.activate([
                infoMessageView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
                infoMessageView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                infoMessageView!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                infoMessageView!.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
            ])
            
        } else {
            if infoMessageView != nil {
                infoMessageView!.removeFromSuperview()
                infoMessageView = nil
            }
            requestsHostingController.view.isHidden = false
        }
    }
}
