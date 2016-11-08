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
        case custom(NSDate, NSDate)
        func startAndEndDates() -> (start: NSDate, end: NSDate) {
            let now = NSDate()
            switch self {
            case .numYears(let years):
                return (now - years.years, now)
            case let custom(start, end):
                return (start, end)
            default:
                return (NSDate(timeIntervalSince1970: 1422751084),  NSDate())
            }
        }
    }
    let dateRange: DateRangeParameter
    let transactionTypes: [String]
    static var defaultParameters: CommonChartParameters {
        return CommonChartParameters(dateRange: .numYears(1), transactionTypes: [])
    }
}
