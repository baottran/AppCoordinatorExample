//
//  SignInCoordinator.swift
//  AppCoordinatorExample
//
//  Created by baottran on 5/28/19.
//  Copyright © 2019 baottran. All rights reserved.
//

import Foundation

protocol SignInCoordinatorDelegate: CoordinatorDelegate {
    func userAuthenticated()
}

class SignInCoordinator: Coordinator {
    
    weak var delegate: SignInCoordinatorDelegate?
    
    override func start() {
        let loginVC = LogInViewController()
        loginVC.delegate = self
        viewController = loginVC
    }
}

extension SignInCoordinator: LogInViewControllerDelegate {
    func login() {
        PersistanceManager.logUserIn()
        delegate?.didFinish(coordinator: self)
        delegate?.userAuthenticated()
    }
}
