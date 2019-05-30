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
        
        let frame = UIScreen.main.bounds
        let window = UIWindow(frame: frame)
        self.window = window
    
        coordinator = AppCoordinator(window: window)
        coordinator?.start()
        
        return true
    }
}

