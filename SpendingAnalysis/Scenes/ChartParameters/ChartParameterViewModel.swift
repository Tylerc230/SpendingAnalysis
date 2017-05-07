//
//  ChartParameterViewModel.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/12/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import RxSwift
import RxSugar
enum ChartParameter {
    case dateRange, transactionTypes
}

struct ChartParameterViewModel {
    let closeTapped: Observable<Void>
    let expandedParamters: Observable<[Bool]>
    let dateRangeString: Observable<String>
    let parameterValues: Observable<CommonChartParameters>
    init(closeTapped: Observable<Void>, parameterTappedAtIndex: Observable<Int>, parameterValues: Observable<CommonChartParameters>) {
        self.closeTapped = closeTapped
        self.parameterValues = parameterValues
        expandedParamters = parameterTappedAtIndex
            .map {
                var expandedRows = Array<Bool>(repeating: false, count: 2)
                expandedRows[$0] = true
                return expandedRows
            }
            .startWith(Array<Bool>(repeating: false, count: 2))
        dateRangeString = parameterValues.map { $0.dateRange.toString() }
    }
}

extension CommonChartParameters.DateRangeParameter {
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter
    }()

    fileprivate func toString() -> String {
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
            let startText = CommonChartParameters.DateRangeParameter.dateFormatter.string(from: start)
            let endText = CommonChartParameters.DateRangeParameter.dateFormatter.string(from: end)
            text = "\(startText) - \(endText)"
        }
        return text
    }
}
