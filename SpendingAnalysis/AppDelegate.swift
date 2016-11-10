//
//  AppDelegate.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 5/11/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit
import TBAppScaffold

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let router = Router(eventTransitionMap: transitionForEvent)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard let nav = window?.rootViewController as? UINavigationController else {
            fatalError()
        }
        router.sendEvent(.appLaunch, withSource: nav)
        return true
    }
}

