//
//  MenuBarViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-07.
//

import UIKit

enum UserRole {
    case admin
    case employee
}

class MenuBarViewController: UIViewController {
    // Change this to .employee if it's an employee page
    public var userRole: UserRole {
            return .admin
    }
    
    var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the stack view
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the stack view to the view
        view.addSubview(stackView)
        
        // Set constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50) // Adjust height as needed
            
        ])
        
        // Create and add the buttons from stack view
        let dashboardButton = createButton(title: "Dashboard", imageName: "square.and.pencil")
        let scheduleButton = createButton(title: "Schedule", imageName: "calendar")
        
        stackView.addArrangedSubview(dashboardButton)
        stackView.addArrangedSubview(scheduleButton)
        
        if userRole == .admin {
            let attendanceButton = createButton(title: "Attendance", imageName: "person.2")
            stackView.addArrangedSubview(attendanceButton)
        }
        
        let requestButton = createButton(title: "Request", imageName: "clock")
        let moreButton = createButton(title: "More", imageName: "ellipsis")
        
        stackView.addArrangedSubview(requestButton)
        stackView.addArrangedSubview(moreButton)
    }
    
    private func createButton(title: String, imageName: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        
        let image = UIImage(systemName: imageName)
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let imageWithConfiguration = image?.withConfiguration(configuration)
        
        let imageView = UIImageView(image: imageWithConfiguration)
        imageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = .center
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        
        // Add tap gesture recognizer to the stack view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(tapGesture)
        
        return stackView
    }

    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        guard let stackView = sender.view as? UIStackView,
            let index = stackView.superview?.subviews.firstIndex(of: stackView) else {
            return
        }
        
        switch index {
            case 0:
                dashboardButtonTapped()
            case 1:
                scheduleButtonTapped(isAdmin: userRole == .admin)
            case 2:
                userRole == .admin ? attendanceButtonTapped() : requestButtonTapped()
            case 3:
                userRole == .admin ? requestButtonTapped() : moreButtonTapped()
            case 4:
                moreButtonTapped()

            default:
                break
        }
    }
    
    @objc private func dashboardButtonTapped() {
        // Perform action for Dashboard button
        print("Dashboard button tapped")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardView")
        
        Utils.navigate(vc, self)
    }
    
    @objc private func scheduleButtonTapped(isAdmin: Bool) {
        // Perform action for Schedule button
        print( isAdmin ? "Scheduler button tapped" : "Schedule button tapped")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScheduleView")
        
        Utils.navigate(vc, self)
    }
    
    @objc private func requestButtonTapped() {
        // Perform action for Request button
        print("Request button tapped")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RequestView")
        
        Utils.navigate(vc, self)
    }
    
    @objc private func moreButtonTapped() {
        // Perform action for More button
        print("More button tapped")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MoreView")
        
        Utils.navigate(vc, self)
    }
    
    @objc private func attendanceButtonTapped() {
        // Perform action for Attendance button
        print("Attendance button tapped")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AttendanceView")
        
        Utils.navigate(vc, self)
    }
}
