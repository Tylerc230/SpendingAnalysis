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
    
    func toLineChartData(_ transactionSets: [String: TransactionSet]) -> LineChartData {
        let sets: [LineChartDataSet] = transactionSets.map { (groupName, dataFrame) in
            return dataFrame.toLineChartDataSet(groupName, fromColumn: "amount")
        }
        return LineChartData(dataSets: sets)
    }
}
