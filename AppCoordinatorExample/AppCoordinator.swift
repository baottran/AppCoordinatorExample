//
//  AppCoordinator.swift
//  AppCoordinatorExample
//
//  Created by baottran on 5/20/19.
//  Copyright © 2019 baottran. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator {
    
    var currentTabBarVC: UITabBarController?
    var currentLoginVC: LoginViewController?
    
    init(){
        
    }
    
    func start() -> UIViewController {
        if PersistanceManager.userIsLoggedIn() {
            return setupMain()
        } else {
            return setupLoginVC()
        }
    }
    
    func setup(rootViewController: UIViewController){
        let window = UIApplication.shared.keyWindow
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
    }
    
    func setupMain() -> UITabBarController {
        
        let tabBarVC = UITabBarController()

        let yellowVC = UIViewController()
        let blueVC = UIViewController()
        let grayVC = UIViewController()

        var controllers: [UINavigationController] = [yellowVC, blueVC, grayVC].map { vc in
            let nav = UINavigationController(rootViewController: vc)
            return nav
        }

        yellowVC.view.backgroundColor = .yellow
        yellowVC.tabBarItem = UITabBarItem(title: "yellow", image: nil, selectedImage: nil)

        blueVC.view.backgroundColor = .blue
        blueVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)

        grayVC.view.backgroundColor = .gray
        grayVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)


        tabBarVC.viewControllers = controllers

        self.currentTabBarVC = tabBarVC
        
        return tabBarVC
    }
    
    func setupLoginVC() -> UIViewController {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        return loginVC
    }
}

extension AppCoordinator: LoginViewControllerDelegate {
    func login() {
        let tabVC = setupMain()
        setup(rootViewController: tabVC)
    }
}

protocol Coordinator {
    func start()
}

class JobsCoordinator: Coordinator {
    
    func start(){
        
    }
}


