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
    let viewModel = ChartParameterViewModel()
    let transitioningDelegate = PopModalTransitioningDelegate()
    let dispose = DisposeBag()
    func wire(viewController: ChartParameterViewController) {
        viewController.modalPresentationStyle = .Custom
        viewController.transitioningDelegate = transitioningDelegate;
        dispose
            ++ viewModel.closeTapped <~ viewController.parameterView.closeTapped
            ++ viewController.parameterView.chartParameters <~ viewModel.chartParameters
    }
}