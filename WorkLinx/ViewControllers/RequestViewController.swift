//
//  RequestViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-08.
//

import UIKit

class RequestViewController: MenuBarViewController {
    
    var buttonGroup: ButtonGroup!
    var isGoingBack = false
    var tab = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add nav bar with back optional button
        let navigationBar = CustomNavigationBar(title: "Requests")
        
        if isGoingBack {
            let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
            
            navigationBar.items?.first?.leftBarButtonItem = backButton
            
            // Remove menu bar at bottom when adding go back button in navigation
            menuBarStack.removeFromSuperview()
        }
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        // Create buttons and add them to the view
        let button1 = createButton(withTitle: "Time Off")
        let button2 = createButton(withTitle: "Shifts")
        let button3 = createButton(withTitle: "OpenShifts")
        
        // Set the initial state
        switch tab
        {
        case "Time Off Requests" :
            button1.isSelected = true
            button2.isSelected = false
            button3.isSelected = false
        case "Shift Requests" :
            button1.isSelected = false
            button2.isSelected = true
            button3.isSelected = false
        case "OpenShift Available" :
            button1.isSelected = false
            button2.isSelected = false
            button3.isSelected = true
        default :
            break
        }
        
        let buttonsStack = UIStackView(arrangedSubviews: [button1, button2, button3])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 0
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            // Constraints for button stack
            buttonsStack.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Equal width for buttons
            button1.widthAnchor.constraint(equalTo: button2.widthAnchor),
            button1.widthAnchor.constraint(equalTo: button3.widthAnchor),
            
            // Height constraint for buttons (optional)
            button1.heightAnchor.constraint(equalToConstant: 40),
            button2.heightAnchor.constraint(equalToConstant: 40),
            button3.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        // Create the button group with the buttons
        buttonGroup = ButtonGroup(buttons: [button1, button2, button3], targetViewController: self)
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    private func createButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        
        // Set background color for normal state
        button.backgroundColor = .lightGray
        
        // Set custom background image for selected state
        let selectedColor = UIColor(red: 0.2, green: 0.5, blue: 0.8, alpha: 1.0)
        let selectedImage = image(withColor: selectedColor, cornerRadius: 5)
        button.setBackgroundImage(selectedImage, for: .selected)
        
        return button
    }
    
    private func image(withColor color: UIColor, cornerRadius: CGFloat) -> UIImage {
        let size = CGSize(width: cornerRadius * 2 + 1, height: cornerRadius * 2 + 1)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            color.setFill()
            let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius)
            path.fill()
        }
        return image.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
    }
    
    @objc func timeOffButtonTapped() {
        print("Time Off button was tapped.")
        // Implement your custom action for the Time Off button here
    }
    
    @objc func shiftsButtonTapped() {
        print("Shifts button was tapped.")
        // Implement your custom action for the Shifts button here
    }
    
    @objc func openShiftsButtonTapped() {
        print("OpenShifts button was tapped.")
        // Implement your custom action for the OpenShifts button here
    }
}
