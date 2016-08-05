//
//  MainMenuViewModel.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 7/24/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import TBAppScaffold
import RxSwift

struct MainMenuViewModel: ViewModel {
    let transactionByTimeTapped = PublishSubject<Void>()
    let reconcileTapped = PublishSubject<Void>()
    var events: Observable<TransitionEvent> {
        let transitionEvents = [
            transactionByTimeTapped.map { _ in TransitionEvent.showTransactionByTime },
            reconcileTapped.map { _ in TransitionEvent.showReconcile}
            ]
        return transitionEvents.toObservable().merge()
    }
}