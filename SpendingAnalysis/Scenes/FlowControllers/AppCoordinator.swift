//
//  AppCoordinator.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 3/23/17.
//  Copyright © 2017 13bit consulting. All rights reserved.
//

import UIKit
import RxSwift
class AppCoordinator: FlowCoordinator  {
    let navController: UINavigationController
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    func start() {
        showMainMenu()
    }
    
    func showMainMenu() {
        let mainMenu = createMainMenu()
        mainMenu.viewModel?
            .menuItemSelected.map(viewController)
            .subscribe(onNext: transition)
            .addDisposableTo(mainMenu.disposeBag)
        self.navController.viewControllers = [mainMenu]
    }
    
    func transition(toViewController viewController: UIViewController) {
        self.navController.pushViewController(viewController, animated: true)
    }
}

fileprivate func viewController(fromMenuItem menuItem: MainMenuViewModel.MenuItem) -> UIViewController {
    switch menuItem {
    case .transactionsByTime:
        return createTransactionsByTime()
    case .reconcile:
        return createReconcile()
    }
}

fileprivate func createMainMenu() -> MainMenuViewController {
    let storyboard = UIStoryboard(name: "MainMenu", bundle: nil)
    guard let mainMenu = storyboard.instantiateInitialViewController() as? MainMenuViewController else {
        fatalError("Failed to create main menu")
    }
    let viewModel = MainMenuViewModel(transactionByTimeTapped: mainMenu.transactionByTimeTapped, reconcileTapped: mainMenu.reconcileTapped)
    mainMenu.viewModel = viewModel
    return mainMenu
}

fileprivate func createTransactionsByTime() -> TransactionsByTimeViewController {
    let storyboard = UIStoryboard(name: "Analysis", bundle: nil)
    guard let viewController = storyboard.instantiateViewController(withIdentifier: "TransactionsByTimeViewController") as? TransactionsByTimeViewController else {
        fatalError("Incorrect ViewController")
    }
    
    let viewModel = TransactionsByTimeViewModel(networkInterface: NetworkInterface(),
                                                viewWillAppear: viewController.viewWillAppear,
                                                refresh: .never(),
                                                showParameters: viewController.parameterButtonTapped)
    viewController.viewModel = viewModel
    return viewController
}

fileprivate func createReconcile() -> UIViewController {
    fatalError()
}
