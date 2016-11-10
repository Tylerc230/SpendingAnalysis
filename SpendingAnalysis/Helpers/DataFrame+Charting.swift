//
//  DataFrame+Charting.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/10/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import Charts
protocol GraphableValueType {
    var value: Double { get }
}

extension Double {
    init(graphableValue: GraphableValueType) {
        self = graphableValue.value
    }
}

extension Float: GraphableValueType {
    var value: Double {
        return Double(self)
    }
}

extension DataFrame where Data: GraphableValueType  {
    func toLineChartDataSet(_ setName: String, fromColumn columnName: String) -> LineChartDataSet {
        let dataEntries: [ChartDataEntry] = indicies.enumerated().map { (idx, dataFrameIndex) in
            let data = Double(graphableValue: self[dataFrameIndex, columnName])
            return ChartDataEntry(x: data, y: Double(idx))
        }
        return LineChartDataSet(values: dataEntries, label: setName)
    }
}
