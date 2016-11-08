//
//  ChartParameterViewModel.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/12/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import TBAppScaffold
import RxSwift
enum ChartParameter {
    case dateRange, transactionTypes
}

private let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .NoStyle
    formatter.dateStyle = .ShortStyle
    return formatter
}()

struct ChartParameterViewModel: ViewModel {
    let closeTapped = PublishSubject<Void>()
    let currentChartParameter: BehaviorSubject<CommonChartParameters>
    let parameterTappedAtIndex = PublishSubject<Int>()
    var events: Observable<TransitionEvent> {
        return closeTapped.map { .chartParametersDismissed }
    }
    
    var chartParameters: Observable<[ChartParameter]> {
        return Observable.just([ChartParameter.dateRange, ChartParameter.transactionTypes])
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
    
    var dateRangeString: Observable<String> {
        return currentChartParameter.map { $0.dateRange.toString() }
    }
    
    init() {
        let initialParameters = CommonChartParameters(dateRange: .numYears(0), transactionTypes: [])
        currentChartParameter = BehaviorSubject<CommonChartParameters>(value: initialParameters)
    }
}

extension CommonChartParameters.DateRangeParameter {
    private func toString() -> String {
        let text: String
        switch self {
        case let .numYears(years):
            text = "\(years) years"
        case let .numMonths(months):
            text = "\(months) months"
        case .yearsAgo(let years) where years == 0:
            text = "ytd"
        case .yearsAgo(let years) :
            text = years == 1 ? "1 year ago" : "\(years) years ago"
        case .monthsAgo(let months) where months == 0:
            text = "mtd"
        case .monthsAgo(let months):
            text = months == 1 ? "1 month ago" : "\(months) months ago"
        case .custom(let start, let end):
            let startText = dateFormatter.stringFromDate(start)
            let endText = dateFormatter.stringFromDate(end)
            text = "\(startText) - \(endText)"
        }
        return text
    }
}
