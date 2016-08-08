//
//  TransactionsByTimeViewModel.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 8/5/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import TBAppScaffold
import RxSwift

struct TransactionsByTimeViewModel: ViewModel {
    var events: Observable<TransitionEvent> {
        return Observable.never()
    }
}