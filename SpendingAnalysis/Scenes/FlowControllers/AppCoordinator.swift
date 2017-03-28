//
//  AppCoordinator.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 3/23/17.
//  Copyright © 2017 13bit consulting. All rights reserved.
//

import UIKit
class AppCoordinator: FlowCoordinator  {
    let navController: UINavigationController
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    func start() {
        showMainMenu()
    }
    
    func showMainMenu() {
        let storyboard = UIStoryboard(name: "MainMenu", bundle: nil)
        guard let mainMenu = storyboard.instantiateInitialViewController() as? MainMenuViewController else {
            return
        }
        self.navController.viewControllers = [mainMenu]
    }
}
