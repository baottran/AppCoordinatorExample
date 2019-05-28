//
//  AppCoordinator.swift
//  AppCoordinatorExample
//
//  Created by baottran on 5/20/19.
//  Copyright © 2019 baottran. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var tabBarCoordinator: TabCoordinator?
    var signInCoordinator: SignInCoordinator?
    
    override func start() {
        if PersistanceManager.userIsLoggedIn() {
            setupTabCoordinator()
        } else {
            setupSignInCoordinator()
        }
    }
    
    func setupTabCoordinator(){
        let tabCoordinator = TabCoordinator(navigationController: navigationController, parent: nil)
        tabCoordinator.start()
        setup(rootViewController: tabCoordinator.tabBarVC)
    }
    
    func setupSignInCoordinator(){
        let loginCoordinator = SignInCoordinator(navigationController: navigationController, parent: nil)
        loginCoordinator.delegate = self
        loginCoordinator.start()
        signInCoordinator = loginCoordinator
    }
    
    // Helper
    
    func setup(rootViewController: UIViewController){
        let window = UIApplication.shared.keyWindow
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
    }
}

extension AppCoordinator: SignInCoordinatorDelegate {
    func didFinish(coordinator: Coordinator) {
       start()
    }
}
