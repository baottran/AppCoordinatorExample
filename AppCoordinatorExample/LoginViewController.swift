//
//  LoginViewController.swift
//  AppCoordinatorExample
//
//  Created by baottran on 5/25/19.
//  Copyright © 2019 baottran. All rights reserved.
//

import UIKit

protocol LogInViewControllerDelegate: class {
    func login()
}

class LogInViewController: UIViewController {
    
    
    weak var delegate: LogInViewControllerDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        
        let loginButton = UIButton(frame: .zero)
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func login(){
        delegate?.login()
    }
}
