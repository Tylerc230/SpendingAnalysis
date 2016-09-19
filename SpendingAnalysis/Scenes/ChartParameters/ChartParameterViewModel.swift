//
//  ChartParameterViewModel.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/12/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import TBAppScaffold
import RxSwift

struct ChartParameterViewModel: ViewModel {
    let closeTapped = PublishSubject<Void>()
    let currentChartParameter: BehaviorSubject<CommonChartParameters>
    let parameterTappedAtIndex = PublishSubject<Int>()
    var chartParameterStrings: Observable<[String]> {
        return currentChartParameter.map(chartParameterToStringArray)
    }
    var events: Observable<TransitionEvent> {
        return closeTapped.map { .chartParametersDismissed }
    }
    
    var expandedParameters: Observable<[Bool]> {
        return parameterTappedAtIndex
            .map {
                var expandedRows = Array<Bool>(count: 2, repeatedValue: false)
                expandedRows[$0] = true
                return expandedRows
            }
            .startWith(Array<Bool>(count: 2, repeatedValue: false))
    }
    
    
    init() {
        let initialParameters = CommonChartParameters(dateRange: .yearToDate, transactionTypes: [])
        currentChartParameter = BehaviorSubject<CommonChartParameters>(value: initialParameters)
    }
}

let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .NoStyle
    formatter.dateStyle = .ShortStyle
    return formatter
}()

private func chartParameterToStringArray(chartParameter: CommonChartParameters) -> [String] {
    return [chartParameter.dateRange.toString(), "Types here"]
}

extension CommonChartParameters.DateRangeParameter {
    private func toString() -> String {
        let text: String
        switch self {
        case .yearToDate:
            text = "ytd"
        case .monthToDate:
            text = "mtd"
        case .years(let years):
            text = years == 1 ? "1 year" : "\(years) years"
        case .months(let months):
            text = months == 1 ? "1 month" : "\(months) months"
        case .custom(let start, let end):
            let startText = dateFormatter.stringFromDate(start)
            let endText = dateFormatter.stringFromDate(end)
            text = "\(startText) - \(endText)"
        }
        return text
    }
}
