//
//  RegisterViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-06-27.
//

import UIKit

class RegisterViewController: UIViewController {
    public var emailAddress: String = ""
    public var password: String = ""
    
    @IBOutlet weak var employeeBttn: UIButton!
    @IBOutlet weak var employerBttn: UIButton!

    
    @IBAction func employeeBttnTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterEmployeeView")
        
        Utils.navigate(vc, self)
    }
    
    @IBAction func employerBttnTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterEmployerView")
        
        Utils.navigate(vc, self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(emailAddress, password)
        
        // Add nav bar with back button
        let navigationBar = CustomNavigationBar(title: "Register")
        let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        
        navigationBar.items?.first?.leftBarButtonItem = backButton
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Add text and styles for buttons
        let employeeAttributedText = NSMutableAttributedString(string: "I'm an employee\n\nI want to join my time and get my schedule.")
        employeeAttributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], range: NSRange(location: 0, length: 15))
        
        employeeBttn.setAttributedTitle(employeeAttributedText, for: .normal)
        employeeBttn.titleLabel?.numberOfLines = 0

        
        let employerAttributedText = NSMutableAttributedString(string: "I’m setting up my business\n\nI want to create a workplace, set a schedule and invite employees.")
        employerAttributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], range: NSRange(location: 0, length: 26))
        
        employerBttn.setAttributedTitle(employerAttributedText, for: .normal)
        employerBttn.titleLabel?.numberOfLines = 0

    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
}

