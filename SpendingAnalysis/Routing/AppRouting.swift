//
//  AppRouting.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 7/24/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import Foundation
import TBAppScaffold

enum TransitionEvent {
    case appLaunch
    case showTransactionByTime
    case showReconcile
}

enum SegueId: String, SegueIdType {
    case transactionsByTimeSegue
    var identifier: String {
        return rawValue
    }
}

func transitionForEvent(source: UIViewController, event: TransitionEvent) -> AnyTransition<TransitionEvent> {
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
    case .showReconcile:
        fatalError()
    case .showTransactionByTime:
        let transactionsByTimeWiring = TransactionsByTimeWiring()
        let transition = SegueTransition(sourceViewController: source, segueId: SegueId.transactionsByTimeSegue, wiring: transactionsByTimeWiring)
        return AnyTransition(transition: transition)
    }
}
