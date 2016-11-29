//
//  TransactionsByTimeView.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 8/7/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

class TransactionsByTimeView: UIView {
    @IBOutlet var lineChartView: LineChartView!
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var lineChartData: AnyObserver<[String: TransactionSet]> {
        return UIBindingObserver(UIElement: self) { [unowned self] (view, data) in
            view.lineChartView.data = self.toLineChartData(data)
        }.asObserver()
    }
    
    func toLineChartData(_ transactionSets: [String: TransactionSet]) -> LineChartData {
        let sets: [LineChartDataSet] = transactionSets.map { (groupName, dataFrame) in
            return dataFrame.toLineChartDataSet(groupName, fromColumn: "amount")
        }
        sets.forEach(self.applyStyle)
        return LineChartData(dataSets: sets)
    }
    
    func applyStyle(dataSet: LineChartDataSet) {
        dataSet.circleColors = [.black]
        dataSet.circleRadius = 3.0
        dataSet.drawCircleHoleEnabled = false
        dataSet.colors = [.black]
        dataSet.valueFormatter = currencyFormatter
    }
}

extension NumberFormatter: IValueFormatter {
    public func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        let nsNumber = NSNumber(floatLiteral: value)
        return string(from: nsNumber) ?? "??"
    }
    
}
