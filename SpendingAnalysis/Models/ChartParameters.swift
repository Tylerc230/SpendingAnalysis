//
//  CommonChartParameters.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/16/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import Foundation
import SwiftDate

struct CommonChartParameters {
    enum DateRangeParameter {
        case numYears(Int), numMonths(Int)//Represents range starting x number of years (or months) going to the present
        case yearsAgo(Int), monthsAgo(Int)//Represents 1 year (or month) starting x years (or months ago). 0 represents year to date
        case custom(Date, Date)
        func startAndEndDates() -> (start: Date, end: Date) {
            let now = Date()
            switch self {
            case .numYears(let numberOf):
                return (now - numberOf.years, now)
            case .numMonths(let numberOf):
                return (now - numberOf.months, now)
            case .yearsAgo(let numberOf) where numberOf == 0:
                return (now.startOfYear, now)
            case .yearsAgo(let numberOf):
                let start = now - numberOf.years
                return (start, start + 1.year)
            case .monthsAgo(let numberOf) where numberOf == 0:
                return (now.startOfMonth, now)
            case .monthsAgo(let numberOf):
                let start = now - numberOf.months
                return (start, start + 1.month)
            case let .custom(start, end):
                return (start, end)
            }
        }
    }
    let dateRange: DateRangeParameter
    let transactionTypes: [String]
    static var defaultParameters: CommonChartParameters {
        return CommonChartParameters(dateRange: .numYears(1), transactionTypes: [])
    }
}

extension Date {
    var startOfYear: Date {
        return startOf(component: .year)
    }
    
    var startOfMonth: Date {
        return startOf(component: .month)
    }
}
