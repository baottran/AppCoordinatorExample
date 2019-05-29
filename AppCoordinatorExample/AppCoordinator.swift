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
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        
        // initialize
        let navigationController = NavigationController()
        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        super.init(navigationController: navigationController, parent: nil)
    }
    
    required init(navigationController: NavigationController, parent: Coordinator?) {
        fatalError("init(navigationController:parent:) has not been implemented")
    }
    
    override func start() {
        setupInitialViewController()
    }
    
    func setupInitialViewController(){
        if PersistanceManager.userIsLoggedIn() {
            setupTabs()
        } else {
            setupSignInCoordinator()
        }
    }
    
    func setupSignInCoordinator(){
        let loginCoordinator = SignInCoordinator(navigationController: navigationController, parent: self)
        loginCoordinator.delegate = self
        loginCoordinator.start()
        push(child: loginCoordinator)
    }
    
    
    func setupTabs() {
        
        let tabBarVC = UITabBarController()
        
        let contactsCoordinator = ContactCoordinator(navigationController: NavigationController(), parent: self)
        let bookmarkCoordinator = BookmarkCoordinator(navigationController: NavigationController(), parent: self)
        let historyCoordinator = HistoryCoordinator(navigationController: NavigationController(), parent: self)
        
        childCoordinators = [contactsCoordinator, bookmarkCoordinator, historyCoordinator]
        
        _ = childCoordinators.map { $0.start() }
        tabBarVC.viewControllers = childCoordinators.map { $0.viewController }
        viewController = tabBarVC
        
        // make key, not sure why its not pushing?
        window.rootViewController = tabBarVC
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: SignInCoordinatorDelegate {
    func userAuthenticated(){
        setupTabs()
    }
}
