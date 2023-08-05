//
//  TimeOffViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-05.
//

import UIKit

class TimeOffViewController: UIViewController {
    
    private var timeOffTableView: UITableView!
    private var infoMessageView: UIView? // Info message view
    private var data = Utils.getTimeOffData()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Add nav bar
        let navigationBar = CustomNavigationBar(title: "Time Off")
        let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        
        navigationBar.items?.first?.leftBarButtonItem = backButton
        
        if let addButtonImage = UIImage(systemName: "plus") {
            // Resize and recolor the addButton image
            let symbolConfiguration = UIImage.SymbolConfiguration(weight: .heavy)
            let resizedImage = addButtonImage.withConfiguration(symbolConfiguration).withTintColor(.black, renderingMode: .alwaysOriginal)
            let addButton = UIBarButtonItem(image: resizedImage, style: .done, target: self, action: #selector(addButtonTapped))
            
            navigationBar.items?.first?.rightBarButtonItem = addButton
        }
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        timeOffTableView = UITableView()
        
        if data.isEmpty {
            // Setup the info message view initially
            setupInfoMessageView()
        } else {
            view.addSubview(timeOffTableView)
            NSLayoutConstraint.activate([
                timeOffTableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
                timeOffTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                timeOffTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                timeOffTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonTapped() {
        print("Add")
    }
    
    // Function to update the info message view based on data availability
    func setupInfoMessageView() {
        if  data.isEmpty {
            if infoMessageView == nil {
                // Create the info message view
                let infoMessageView = EmptyListMessageView(message: "No time off request sceduled.\nTap + to request a time off.")
                view.addSubview(infoMessageView)

                NSLayoutConstraint.activate([
                    infoMessageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
                    infoMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    infoMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    infoMessageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
                ])
            }
            timeOffTableView.separatorStyle = .none
        } else {
            infoMessageView?.removeFromSuperview()
            infoMessageView = nil
            timeOffTableView.separatorStyle = .singleLine
        }
    }
}
