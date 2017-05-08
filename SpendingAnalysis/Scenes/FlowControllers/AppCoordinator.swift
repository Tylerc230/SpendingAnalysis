//
//  AppCoordinator.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 3/23/17.
//  Copyright © 2017 13bit consulting. All rights reserved.
//

import UIKit
import RxSwift
import RxSugar

struct AppCoordinator: FlowCoordinator  {
    let navController: UINavigationController
    let transactionByTimeCoordinator: TransactionsByTimeCoordinator
    init(navController: UINavigationController) {
        self.navController = navController
        self.transactionByTimeCoordinator = TransactionsByTimeCoordinator(navController: navController)
    }
    
    func start() {
        showMainMenu()
    }
    
    func showMainMenu() {
        let mainMenu = createMainMenu()
        self.navController.viewControllers = [mainMenu]
    }
    
    private func createMainMenu() -> MainMenuViewController {
        let storyboard = UIStoryboard(name: "MainMenu", bundle: nil)
        guard let mainMenu = storyboard.instantiateInitialViewController() as? MainMenuViewController else {
            fatalError("Failed to create main menu")
        }
        let viewModel = MainMenuViewModel(transactionByTimeTapped: mainMenu.transactionByTimeTapped, reconcileTapped: mainMenu.reconcileTapped)
        viewModel.menuItemSelected
            .subscribe(onNext: transition)
            .addDisposableTo(mainMenu.disposeBag)
        mainMenu.viewModel = viewModel
        return mainMenu
    }
    func transition(forMenuItem menuItem: MainMenuViewModel.MenuItem) {
        switch menuItem {
        case .transactionsByTime:
            transactionByTimeCoordinator.start()
        case .reconcile:
            break
        }
    }
}

