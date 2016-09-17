//
//  CommonChartParameters.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/16/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import Foundation

struct CommonChartParameters {
    enum DateRangeParameter {
        case yearToDate, monthToDate, years(Int), months(Int), custom(NSDate, NSDate)
    }
    let dateRange: DateRangeParameter
    let transactionTypes: [String]
}
