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

struct TransactionsByTimeCoordinator: NavFlowCoordinator {
    let push: AnyObserver<UIViewController>
    let present: AnyObserver<UIViewController>
    let dismiss: AnyObserver<Void>
    let storyboard = UIStoryboard(name: "Analysis", bundle: nil)
    let networkInterface = NetworkInterface()
    
    init(push: AnyObserver<UIViewController>, present: AnyObserver<UIViewController>, dismiss: AnyObserver<Void>) {
        self.push = push
        self.present = present
        self.dismiss = dismiss
    }
    
    func start() {
        let transactionByTimeViewController = createTransactionsByTime()
        push.onNext(transactionByTimeViewController)
    }
    
    fileprivate func createTransactionsByTime() -> TransactionsByTimeViewController {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "TransactionsByTimeViewController") as? TransactionsByTimeViewController else {
            fatalError("Incorrect ViewController")
        }
        let updatedChartParameters = PublishSubject<CommonChartParameters>()
        let viewModel = TransactionsByTimeViewModel(input: (
            viewWillAppear: viewController.viewWillAppear,
            showParametersTapped: viewController.parameterButtonTapped,
            updatedChartParameters: updatedChartParameters
            ),
                                                    networkInterface: networkInterface)
        
        viewController.disposeBag
            ++ self.present <~ viewModel.editQueryParameters.map(createChartParametersView(parameterObserver: updatedChartParameters.asObserver()))
        viewController.viewModel = viewModel
        return viewController
    }

    fileprivate func createChartParametersView(parameterObserver: AnyObserver<CommonChartParameters>) -> () -> ChartParameterViewController {
        return {
            guard let viewController = self.storyboard.instantiateViewController(withIdentifier: "ChartParameterViewController") as? ChartParameterViewController else {
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

