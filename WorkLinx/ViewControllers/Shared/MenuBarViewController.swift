//
//  MenuBarViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-07.
//

import UIKit

class MenuBarViewController: UIViewController {
    var menuBarStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the stack view
        menuBarStack = UIStackView()
        menuBarStack.axis = .horizontal
        menuBarStack.distribution = .fillEqually
        menuBarStack.spacing = 0
        menuBarStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the stack view to the view
        view.addSubview(menuBarStack)
        
        // Set constraints for the stack view
        NSLayoutConstraint.activate([
            menuBarStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBarStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuBarStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            menuBarStack.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
        // Create and add the buttons from stack view
        let dashboardButton = createButton(title: "Dashboard", imageName: "square.and.pencil")
        let scheduleButton = createButton(title: "Schedule", imageName: "calendar")
        
        menuBarStack.addArrangedSubview(dashboardButton)
        menuBarStack.addArrangedSubview(scheduleButton)
        
        if Utils.isAdmin {
            let attendanceButton = createButton(title: "Attendance", imageName: "person.2")
            menuBarStack.addArrangedSubview(attendanceButton)
        }
        
        let requestButton = createButton(title: "Request", imageName: "clock")
        let moreButton = createButton(title: "More", imageName: "ellipsis")
        
        menuBarStack.addArrangedSubview(requestButton)
        menuBarStack.addArrangedSubview(moreButton)
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
                scheduleButtonTapped()
            case 2:
                Utils.isAdmin ? attendanceButtonTapped() : requestButtonTapped()
            case 3:
                Utils.isAdmin ? requestButtonTapped() : moreButtonTapped()
            case 4:
                moreButtonTapped()

            default:
                break
        }
    }
    
    @objc private func dashboardButtonTapped() {
        Utils.embedViewControllerInNavigationAndSetAsRoot(DashboardViewController())
    }
    
    @objc private func scheduleButtonTapped() {
        Utils.embedViewControllerInNavigationAndSetAsRoot(ScheduleViewController())
    }
    
    @objc private func requestButtonTapped() {
        Utils.embedViewControllerInNavigationAndSetAsRoot(RequestViewController())
    }
    
    @objc private func moreButtonTapped() {
        Utils.embedViewControllerInNavigationAndSetAsRoot(MoreViewController())
    }
    
    @objc private func attendanceButtonTapped() {
        Utils.embedViewControllerInNavigationAndSetAsRoot(AttendanceViewController())
    }
}
