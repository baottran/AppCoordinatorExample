//
//  TabCoordinator.swift
//  AppCoordinatorExample
//
//  Created by baottran on 5/28/19.
//  Copyright © 2019 baottran. All rights reserved.
//

import Foundation
import UIKit

class ContactCoordinator: Coordinator {
    
    override func start(){
        let vc = UIViewController()
        vc.view.backgroundColor = .yellow
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        viewController = vc
    }
    
}

class BookmarkCoordinator: Coordinator {
    override func start(){
        let vc = UIViewController()
        vc.view.backgroundColor = .green
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        viewController = vc
    }
}

class HistoryCoordinator: Coordinator {
    override func start(){
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        viewController = vc
    }
}

