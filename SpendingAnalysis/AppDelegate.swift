//
//  AppDelegate.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 5/11/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow()
    var coordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navController = UINavigationController()
        window?.rootViewController = navController
        coordinator = AppCoordinator(navController: navController)
        coordinator?.start()
        window?.makeKeyAndVisible()
        return true
    }
}

