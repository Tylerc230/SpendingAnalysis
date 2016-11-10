//
//  AppRouting.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 7/24/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import Foundation
import TBAppScaffold
import RxSwift

enum TransitionEvent {
    case appLaunch
    case showTransactionByTime
    case showReconcile
    case showChartParameters(CommonChartParameters, AnyObserver<CommonChartParameters>)
    case chartParametersDismissed
}

enum SegueId: String, SegueIdType {
    case transactionsByTimeSegue
    case chartParameterSegue
    var identifier: String {
        return rawValue
    }
}

func transitionForEvent(_ source: UIViewController, event: TransitionEvent) -> AnyTransition<TransitionEvent> {
    switch event {
    case .appLaunch:
        let mainMenuWiring = MainMenuWiring()
        let transition = ManualTransition(sourceViewController: source, wiring: mainMenuWiring) {
            guard let nav = source as? UINavigationController else {
                fatalError()
            }
            return nav.topViewController as! MainMenuViewController
        }
        return AnyTransition(transition: transition)
    case let .showChartParameters(initialParameters, chartParameterObserver):
        let wiring = ChartParameterWiring(initialParameters: initialParameters, parameterObserver: chartParameterObserver)
        let transition = SegueTransition(sourceViewController: source, segueId: SegueId.chartParameterSegue, wiring: wiring)
        return AnyTransition(transition: transition)
    case .showReconcile:
        fatalError()
    case .showTransactionByTime:
        let wiring = TransactionsByTimeWiring()
        let transition = SegueTransition(sourceViewController: source, segueId: SegueId.transactionsByTimeSegue, wiring: wiring)
        return AnyTransition(transition: transition)
    case .chartParametersDismissed:
        let manualDismissTransition = ManualDismissTransition(source: source)
        return AnyTransition(transition: manualDismissTransition)
        
    }
}
