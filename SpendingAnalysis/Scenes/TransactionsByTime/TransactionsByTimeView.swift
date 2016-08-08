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
    var lineChartData: AnyObserver<LineChartData> {
        return UIBindingObserver(UIElement: self) { (view, data) in
            view.lineChartView.data = data
        }.asObserver()
    }
}
