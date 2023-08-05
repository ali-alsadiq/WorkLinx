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
                let infoMessageView = EmptyListMessageView(message: "No positions added.\nTap + to add.")
                view.addSubview(infoMessageView)

                NSLayoutConstraint.activate([
                    infoMessageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
                    infoMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    infoMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    infoMessageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
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



