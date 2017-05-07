//
//  TransactionsByTimeCoordinator.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 5/7/17.
//  Copyright © 2017 13bit consulting. All rights reserved.
//

import UIKit
import RxSwift
import RxSugar

struct TransactionsByTimeCoordinator: FlowCoordinator {
    let navController: UINavigationController
    let present: AnyObserver<UIViewController>
    let dismiss: AnyObserver<Void>
    init(navController: UINavigationController) {
        self.navController = navController
        self.present = AnyObserver() { event in
            if case let .next(viewController) = event {
                navController.present(viewController, animated: true, completion: nil)
            }
        }
        self.dismiss = AnyObserver { event in
            if case .next = event {
                navController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func start() {
        let transactionByTimeViewController = createTransactionsByTime()
        navController.pushViewController(transactionByTimeViewController, animated: true)
    }
    
    fileprivate func createTransactionsByTime() -> TransactionsByTimeViewController {
        guard let viewController = analysisStoryboard().instantiateViewController(withIdentifier: "TransactionsByTimeViewController") as? TransactionsByTimeViewController else {
            fatalError("Incorrect ViewController")
        }
        let updateChart = PublishSubject<CommonChartParameters>()
        let viewModel = TransactionsByTimeViewModel(networkInterface: NetworkInterface(),
                                                    viewWillAppear: viewController.viewWillAppear,
                                                    refresh: updateChart,
                                                    showParametersTapped: viewController.parameterButtonTapped)
        viewController.disposeBag
            ++ self.present <~ viewModel.editQueryParameters.map(createChartParametersView(parameterObserver: updateChart.asObserver()))
        viewController.viewModel = viewModel
        return viewController
    }

    fileprivate func createChartParametersView(parameterObserver: AnyObserver<CommonChartParameters>) -> () -> ChartParameterViewController {
        return {
            guard let viewController = analysisStoryboard().instantiateViewController(withIdentifier: "ChartParameterViewController") as? ChartParameterViewController else {
                fatalError("Incorrect ViewController")
            }
            let viewModel = ChartParameterViewModel(closeTapped: viewController.closeTapped, parameterTappedAtIndex: viewController.parameterTappedAtIndex, parameterValues: viewController.parameterValues)
            viewController.dispose
                ++ self.dismiss <~ viewModel.closeTapped
                ++ parameterObserver <~ viewModel.parameterValues
            viewController.viewModel = viewModel
            return viewController
        }
    }

}

func analysisStoryboard() -> UIStoryboard {
    return UIStoryboard(name: "Analysis", bundle: nil)
}
