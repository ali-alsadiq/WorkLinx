//
//  EditRequestViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-11.
//

import Foundation
import UIKit

class EditRequestViewController: UIViewController {
    var navigationBar: CustomNavigationBar!
    var buttonsStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationBar = CustomNavigationBar(title: "Edit Requests")
        let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        navigationBar.items?.first?.leftBarButtonItem = backButton
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let approveButton = createButton(title: "Approve",
                                         target: self,
                                         action: #selector(approveButtonTapped),
                                         color: Utils.darkGreen)
        
        let rejectButton = createButton(title: "Reject",
                                        target: self,
                                        action: #selector(rejectButtonTapped),
                                        color: Utils.darkRed)
        
        let cancelButton = createButton(title: "Cencel",
                                        target: self,
                                        action: #selector(cancelButtonTapped),
                                        color: Utils.darkRed)
        
        
        // Add form elements to a stack
        buttonsStack = UIStackView()
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
        
        if Utils.isAdmin {
            buttonsStack.addArrangedSubview(approveButton)
            buttonsStack.addArrangedSubview(rejectButton)

        } else {
            buttonsStack.addArrangedSubview(cancelButton)
        }
    }
    
    func createStackView(headerLabel: UILabel,
                         valueLabel: UILabel? = nil,
                         imagesStack: UIStackView? = nil) -> UIStackView {
        let stackView = UIStackView()
        stackView.addArrangedSubview(headerLabel)

        if imagesStack != nil {
            stackView.addArrangedSubview(imagesStack!)
        } else {
            stackView.addArrangedSubview(valueLabel!)
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
    
    func createHeaderLabel(text: String) -> UILabel {
        let headerLabel = createLabel(text: text, font: UIFont.systemFont(ofSize: 12, weight: .medium))
        headerLabel.textAlignment = .right
        headerLabel.textColor = .gray
        return headerLabel
    }
    
    
    func createLabel(text: String, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        return label
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc dynamic func approveButtonTapped() {
        // get logic from child class
    }
    
    @objc dynamic func rejectButtonTapped() {
        // get logic from child class
    }
    
    @objc dynamic func cancelButtonTapped() {
        // get logic from child class
    }
}
