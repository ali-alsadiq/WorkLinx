//
//  PositionsViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-31.
//

import UIKit

class PositionsViewController: UIViewController {
    
    private var positionsTableView: UITableView!
    private var infoMessageView: UIView? // Info message view
    private var arrowImageView: UIImageView?
    private var navigationBar: CustomNavigationBar!
    
    private var data = Utils.getPositionsData()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        positionsTableView = UITableView()
        view.backgroundColor = UIColor.white
        
        // Add nav bar
        navigationBar = CustomNavigationBar(title: "Positions")
        let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        
        if let addButtonImage = UIImage(systemName: "plus") {
            // Resize and recolor the addButton image
            let symbolConfiguration = UIImage.SymbolConfiguration(weight: .heavy)
            let resizedImage = addButtonImage.withConfiguration(symbolConfiguration).withTintColor(.black, renderingMode: .alwaysOriginal)
            let addButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(addButtonTapped))
            
            navigationBar.items?.first?.rightBarButtonItem = addButton
        }
        
        navigationBar.items?.first?.leftBarButtonItem = backButton
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        positionsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        if data.isEmpty {
            // Setup the info message view initially
            setupInfoMessageView()
        } else {
            view.addSubview(positionsTableView)
            NSLayoutConstraint.activate([
                positionsTableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
                positionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                positionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                positionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        //registration of the MoreCell which is a UITableViewCell
        positionsTableView.register(PositionCell.self, forCellReuseIdentifier: "positionCell")
        
        positionsTableView.dataSource = self
        positionsTableView.delegate = self
    }
    
    public func reloadData() {
        data = Utils.getPositionsData()
        positionsTableView.reloadData()
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    // Function to handle the + button tap
    @objc func addButtonTapped() {
        let positionsVC = AddPositionViewController()
        positionsVC.positionsTableView = self
        positionsVC.modalPresentationStyle = .fullScreen

        present(positionsVC, animated: true, completion: nil)
    }
    
    // Function to update the info message view based on data availability
    func setupInfoMessageView() {
        if  data.isEmpty {
            if infoMessageView == nil {
                // Create the info message view
                let infoMessageView = UIView()
                infoMessageView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
                infoMessageView.layer.cornerRadius = 8.0
                infoMessageView.translatesAutoresizingMaskIntoConstraints = false // Add this line to disable autoresizing mask constraints
                
                // Create and configure the message label
                let messageLabel = UILabel()
                messageLabel.text = "No positions added.\nTap + to add."
                messageLabel.textAlignment = .center
                messageLabel.numberOfLines = 0
                messageLabel.textColor = .gray
                messageLabel.translatesAutoresizingMaskIntoConstraints = false
                infoMessageView.addSubview(messageLabel)
                
                // Add constraints to the message label
                NSLayoutConstraint.activate([
                    messageLabel.topAnchor.constraint(equalTo: infoMessageView.topAnchor, constant: 8),
                    messageLabel.leadingAnchor.constraint(equalTo: infoMessageView.leadingAnchor, constant: 8),
                    messageLabel.trailingAnchor.constraint(equalTo: infoMessageView.trailingAnchor, constant: -8),
                    messageLabel.bottomAnchor.constraint(equalTo: infoMessageView.bottomAnchor, constant: -8)
                ])
                
                // Create and add the arrow image view
                let arrowImageView = UIImageView(image: UIImage(systemName: "arrow.turn.right.up"))
                arrowImageView.tintColor = .darkGray
                arrowImageView.contentMode = .scaleAspectFit
                arrowImageView.translatesAutoresizingMaskIntoConstraints = false
                infoMessageView.addSubview(arrowImageView)
                
                // Add constraints to the arrow image view
                NSLayoutConstraint.activate([
                    arrowImageView.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
                    arrowImageView.trailingAnchor.constraint(equalTo: infoMessageView.trailingAnchor, constant: 10),
                    arrowImageView.widthAnchor.constraint(equalToConstant: 50),
                    arrowImageView.heightAnchor.constraint(equalToConstant: 100)
                ])
                
                // Add the info message view to the main view
                view.addSubview(infoMessageView)
                
                // Add constraints for the info message view
                NSLayoutConstraint.activate([
                    infoMessageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
                    infoMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    infoMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    infoMessageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100) // Adjust height constraint as needed
                ])
            }
            positionsTableView.separatorStyle = .none
        } else {
            infoMessageView?.removeFromSuperview()
            infoMessageView = nil
            positionsTableView.separatorStyle = .singleLine
        }
    }
}

extension PositionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let role = data[indexPath.section].0.contains("Admins") ? "Administrator" : "User"
        let position = data[indexPath.section].1[indexPath.row]
        
        let editPositionVC = EditPositionViewController(currentPosition: position, role: role, positionsTableView: self)
        editPositionVC.modalPresentationStyle = .fullScreen

        present(editPositionVC, animated: true, completion: nil)
    }
}

extension PositionsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = data[section]
        return sectionData.1.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "positionCell", for: indexPath) as! PositionCell
        
        let postion = data[indexPath.section].1[indexPath.row]
        
        cell.updateView(position: postion)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].0
    }
}



