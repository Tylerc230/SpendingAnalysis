//
//  TransactionsByTimeWiring.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 8/5/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import TBAppScaffold
import RxSugar

struct TransactionsByTimeWiring: Wiring {
    let viewModel = TransactionsByTimeViewModel()
    func wire(viewController: TransactionsByTimeViewController) {
        viewController.disposeBag
            ++ viewModel.queryForCurrentTransactions <~ viewController.viewWillAppear
            ++ viewModel.showParametersView <~ viewController.parameterButtonTapped
            ++ viewController.transactionsByTimeView.lineChartData <~ viewModel.lineChartData()
    }
    
}
