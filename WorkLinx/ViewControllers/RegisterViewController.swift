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
    
//    init(emailAddress: String, password: String){
//        self.emailAddress = emailAddress
//        self.password = password
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(emailAddress, password)
    }
}

