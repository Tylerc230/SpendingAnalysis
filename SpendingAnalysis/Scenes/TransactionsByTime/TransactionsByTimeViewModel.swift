//
//  TransactionsByTimeViewModel.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 8/5/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import TBAppScaffold
import RxSwift
import Charts

struct TransactionsByTimeViewModel: ViewModel {
    let queryForCurrentTransactions = PublishSubject<Void>()
    let networkInterface = NetworkInterface()
    
    var events: Observable<TransitionEvent> {
        return Observable.never()
    }
    
    func lineChartData() -> Observable<LineChartData> {
        return queryForCurrentTransactions
            .asObserver()
            .flatMap {
                return self.networkInterface.getTransactions()
        }
        .map(transactionsToLineChartData)
    }
}

private func transactionsToLineChartData(_: [Transaction]) -> LineChartData {
    fatalError()
}