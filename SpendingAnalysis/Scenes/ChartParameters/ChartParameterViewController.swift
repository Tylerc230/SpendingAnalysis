//
//  ChartParameterViewController.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/12/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit
import RxSwift
import RxSugar

class ChartParameterViewController: UIViewController {
    var viewModel: ChartParameterViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                selectedDateRangeString.dispose()
                return
            }
            dispose
                ++ selectedDateRangeString <~ viewModel.dateRangeString
        }
    }
    
    let closeTapped = PublishSubject<Void>()
    let parameterValues = PublishSubject<CommonChartParameters>()
    let parameterTappedAtIndex = PublishSubject<Int>()
    let selectedDateRangeString = PublishSubject<String>()
    let expandedRows = PublishSubject<[Bool]>()
    
    let dispose = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .custom
        transitioningDelegate = PopModalTransitioningDelegate()
        guard let parameterView = view as? ChartParameterView else {
            fatalError("Missing parameter view")
        }
        dispose
            ++ closeTapped <~ parameterView.closeTapped
            ++ parameterValues <~ parameterView.parameterValues
            ++ parameterTappedAtIndex <~ parameterView.rowSelected
            ++ parameterView.selectedDateRangeString <~ selectedDateRangeString
            ++ parameterView.expandedRows <~ expandedRows
    }
}
