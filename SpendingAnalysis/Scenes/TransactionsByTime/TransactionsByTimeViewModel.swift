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
typealias TransactionSet = DataFrame<NSDate, Float>
struct TransactionsByTimeViewModel: ViewModel {
    let queryForCurrentTransactions = PublishSubject<Void>()
    let showParametersView = PublishSubject<Void>()
    let networkInterface = NetworkInterface()
    
    var events: Observable<TransitionEvent> {
        return showParametersView.map { TransitionEvent.showChartParameters }
    }
    
    func lineChartData() -> Observable<[String: TransactionSet]> {
        return queryForCurrentTransactions
            .asObserver()
            .flatMap {
                return self.networkInterface.getExpensesOverTime(start: NSDate(timeIntervalSince1970: 1422751084), end: NSDate(), includeTypes: ["rides": ["rideshare"], "morts": ["mortgage"]])
        }
        .map(splitDataFrameOnGroups)
    }
}

private func splitDataFrameOnGroups(dataFrame: ExpenseOverTimeResponse) -> [String: TransactionSet] {
    return dataFrame
        .indicies
        .reduce(Set<String>()) { (groups, index) in
            var groups = groups
            groups.insert(index.group)
            return groups
        }
        .reduce([String: TransactionSet]()) { (transactionSets, group) in
            var transactionSets = transactionSets
            transactionSets[group] = dataFrame
                .filterDataFrame{ (index, row) in
                    return index.group == group
                }
                .mapDataFrame{ (indexDataTuple: (index: TimeGroupIndex, row: [Float])) in
                    return (indexDataTuple.index.date, indexDataTuple.row)
            }
            
            return transactionSets
    }
}
