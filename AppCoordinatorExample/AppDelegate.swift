//
//  AppDelegate.swift
//  AppCoordinatorExample
//
//  Created by baottran on 5/20/19.
//  Copyright © 2019 baottran. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var coordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        PersistanceManager.clearUser()
        
        let nav = NavigationController(rootViewController: UIViewController())
        nav.isNavigationBarHidden = true
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
     
        window!.rootViewController = nav
        window!.makeKeyAndVisible()
    
        coordinator = AppCoordinator(navigationController: nav, parent: nil)
        coordinator?.start()
        
        return true
    }
}

