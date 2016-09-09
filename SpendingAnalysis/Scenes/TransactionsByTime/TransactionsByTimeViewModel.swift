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
                return self.networkInterface.getExpensesOverTime(start: NSDate(timeIntervalSince1970: 1422751084), end: NSDate(), includeTypes: ["rides": ["rideshare"], "morts": ["mortgage"]])
        }
        .map(transactionsToLineChartData)
    }
}

private func transactionsToLineChartData(dataFrame: ExpenseOverTimeResponse) -> LineChartData {
    print("\(dataFrame)")
    let xVals = dataFrame.indicies.map { index in
        return index.date
    }
    let empty = [String: [ChartDataEntry]]()
    let dataSets = dataFrame
        .indicies
        .enumerate()
        .reduce(empty) { ( dataSets, enumerated) in
            let offset = enumerated.0
            let dataFrameIndex = enumerated.1
            let setName = dataFrameIndex.group
            let value = Double(dataFrame[dataFrameIndex, "amount"])
            let dataEntry = ChartDataEntry(value: value, xIndex: offset)
            var set = dataSets[setName] ?? []
            set.append(dataEntry);
            var dataSets = dataSets
            dataSets[setName] = set
            return dataSets
    }
    .map { (setName, dataEntry) in
        return LineChartDataSet(yVals: dataEntry, label: setName)
    }
    return LineChartData(xVals: xVals, dataSets: dataSets)
}