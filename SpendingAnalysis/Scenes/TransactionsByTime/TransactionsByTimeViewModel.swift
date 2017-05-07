//
//  TransactionsByTimeViewModel.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 8/5/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import RxSwift
import Charts
typealias GroupDefinition = [String: [String]]
struct TransactionsByTimeViewModel {
    let networkInterface: NetworkInterface
    let queryCurrentTransactions: Observable<CommonChartParameters>
    let lineChartData: Observable<[String: TransactionSet]>
    let xAxisLabels: Observable<[String]>
    let editQueryParameters: Observable<Void>
    
    init(networkInterface: NetworkInterface, viewWillAppear: Observable<Void>, refresh: Observable<CommonChartParameters>, showParametersTapped: Observable<Void>) {
        let initialFetch = viewWillAppear.map { CommonChartParameters.defaultParameters }
        self.networkInterface = networkInterface
        self.editQueryParameters = showParametersTapped
        queryCurrentTransactions = Observable.from([initialFetch, refresh]).merge()
        lineChartData = queryCurrentTransactions.flatMap { currentChartParameters -> Observable<TransactionSet> in
            let (start, end) = currentChartParameters.dateRange.startAndEndDates()
            return networkInterface.getExpensesOverTime(start: start, end: end, binSize: .months(1)).catchErrorJustReturn(TransactionSet(columns:[], data:[]))
            
            }
            .map {
                return ["total_debit": $0]
        }
        xAxisLabels = lineChartData.map{ transactionSets in
            guard let firstSet = transactionSets.values.first else {
                return []
            }
            return firstSet.indicies.map(dateFormatter.string)
        }
    }
    
    func groupedLineChartData(_ includeTypes: GroupDefinition) -> Observable<[String: TransactionSet]> {
        return queryCurrentTransactions
            .flatMap { currentChartParameters in
                return self.networkInterface.getGroupedExpensesOverTime(start: Date(timeIntervalSince1970: 1422751084), end: Date(), includeTypes: includeTypes)
        }
        .map(splitDataFrameOnGroups)
    }
}


private func splitDataFrameOnGroups(_ dataFrame: GroupedTransactionSet) -> [String: TransactionSet] {
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

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd"
    return formatter
}()
