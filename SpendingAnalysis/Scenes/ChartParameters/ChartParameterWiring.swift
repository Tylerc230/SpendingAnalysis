//
//  ChartParameterWiring.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/12/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import TBAppScaffold
import UIKit
import RxSwift
import RxSugar

struct ChartParameterWiring: Wiring {
    let viewModel: ChartParameterViewModel
    let transitioningDelegate = PopModalTransitioningDelegate()
    let parameterObserver: AnyObserver<CommonChartParameters>
    let dispose = DisposeBag()
    init(initialParameters: CommonChartParameters, parameterObserver: AnyObserver<CommonChartParameters>) {
        self.viewModel = ChartParameterViewModel(initialParameters: initialParameters)
        self.parameterObserver = parameterObserver
    }
    
    func wire(_ viewController: ChartParameterViewController) {
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = transitioningDelegate;
        dispose
            ++ viewModel.closeTapped <~ viewController.parameterView.closeTapped
            ++ viewController.parameterView.chartParameters <~ viewModel.chartParameters
            ++ viewController.parameterView.selectedDateRangeString <~ viewModel.dateRangeString
            ++ viewController.parameterView.expandedRows <~ viewModel.expandedParameters
            ++ viewModel.parameterTappedAtIndex <~ viewController.parameterView.rowSelected
            ++ viewModel.parameterValues <~ viewController.parameterView.parameterValues
            ++ self.parameterObserver <~ viewModel.parameterValues
    }
}
