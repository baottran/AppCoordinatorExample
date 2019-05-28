//
//  PersistanceManager.swift
//  AppCoordinatorExample
//
//  Created by baottran on 5/22/19.
//  Copyright © 2019 baottran. All rights reserved.
//

import Foundation

fileprivate let kLoggedIn = "loggedIn"

class PersistanceManager {
    
    static var shared = PersistanceManager()
    
    static func userIsLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: kLoggedIn)
    }
    
    static func logUserIn(){
        UserDefaults.standard.set(true, forKey: kLoggedIn)
    }
    
    static func clearUser(){
        UserDefaults.standard.removeObject(forKey: kLoggedIn)
    }
}
