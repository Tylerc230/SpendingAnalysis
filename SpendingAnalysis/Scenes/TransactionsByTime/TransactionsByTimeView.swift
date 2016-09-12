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
    
    var lineChartData: AnyObserver<[String: TransactionSet]> {
        return UIBindingObserver(UIElement: self) { [unowned self] (view, data) in
            view.lineChartView.data = self.toLineChartData(data)
        }.asObserver()
    }
    
    func toLineChartData(transactionSets: [String: TransactionSet]) -> LineChartData {
        let sets: [LineChartDataSet] = transactionSets.map { (groupName, dataFrame) in
            let dataEntries: [ChartDataEntry] = dataFrame.indicies.enumerate().map { (idx, dataFrameIndex) in
                let value = Double(dataFrame[dataFrameIndex, "amount"])
                return ChartDataEntry(value: value, xIndex: idx)
            }
            return LineChartDataSet(yVals: dataEntries, label: groupName)
        }
        return LineChartData(xVals: transactionSets.first?.1.indicies, dataSets: sets)
    }
}
