//
//  ChartParameterViewController.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/12/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit
import RxSwift

class ChartParameterViewController: UIViewController {
    var currentChartParameters: Observable<CommonChartParameters> {
        return parameterView.dateRangeSelection.map { range in
            return CommonChartParameters(dateRange: range, transactionTypes: [])
        }
    }
    var parameterView: ChartParameterView {
        return view as! ChartParameterView
    }
}
