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
    let lineChartData: Observable<[String: TransactionSet]>
    let xAxisLabels: Observable<[String]>
    let editQueryParameters: Observable<Void>
    
    init(input: (
        viewWillAppear: Observable<Void>,
        showParametersTapped: Observable<Void>,
        updatedChartParameters: Observable<CommonChartParameters>
        ),
        networkInterface: NetworkInterface
        ) {
        editQueryParameters = input.showParametersTapped
        let initialFetch = input.viewWillAppear.map { CommonChartParameters.defaultParameters }
        let queryTransactions = Observable.from([initialFetch, input.updatedChartParameters]).merge()
        lineChartData = fetchLineChartData(forRequests: queryTransactions, networkInterface: networkInterface)
        xAxisLabels = mapXAxisLabels(fromLineChartData: lineChartData)
    }
    
}

func fetchLineChartData(forRequests fetchRequests: Observable<CommonChartParameters>, networkInterface: NetworkInterface) -> Observable<[String: TransactionSet]> {
    return fetchRequests.flatMap { currentChartParameters -> Observable<TransactionSet> in
        let (start, end) = currentChartParameters.dateRange.startAndEndDates()
        return networkInterface.getExpensesOverTime(start: start, end: end, binSize: .months(1)).catchErrorJustReturn(TransactionSet(columns:[], data:[]))
        
        }
        .map {
            return ["total_debit": $0]
    }
}

func mapXAxisLabels(fromLineChartData lineChartData: Observable<[String: TransactionSet]>) -> Observable<[String]> {
    return lineChartData.map { transactionSets in
        guard let firstSet = transactionSets.values.first else {
            return []
        }
        return firstSet.indicies.map(dateFormatter.string)
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

//    func groupedLineChartData(_ includeTypes: GroupDefinition) -> Observable<[String: TransactionSet]> {
//        return queryCurrentTransactions
//            .flatMap { currentChartParameters in
//                return self.networkInterface.getGroupedExpensesOverTime(start: Date(timeIntervalSince1970: 1422751084), end: Date(), includeTypes: includeTypes)
//        }
//        .map(splitDataFrameOnGroups)
//    }
