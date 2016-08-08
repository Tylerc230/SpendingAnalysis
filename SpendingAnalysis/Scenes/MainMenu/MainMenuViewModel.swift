//
//  MainMenuViewModel.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 7/24/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import TBAppScaffold
import RxSwift
import RxSwiftExt

struct MainMenuViewModel: ViewModel {
    let transactionByTimeTapped = PublishSubject<Void>()
    let reconcileTapped = PublishSubject<Void>()
    var events: Observable<TransitionEvent> {
        let transitionEvents = [
            transactionByTimeTapped.mapTo(TransitionEvent.showTransactionByTime),
            reconcileTapped.mapTo(TransitionEvent.showReconcile)
            ].toObservable()
        return transitionEvents.merge()
    }
}