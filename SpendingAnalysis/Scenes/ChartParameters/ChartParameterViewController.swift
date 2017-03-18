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
    var viewModel: ChartParameterViewModel? = nil
    let dispose = DisposeBag()
    var parameterView: ChartParameterView {
        return view as! ChartParameterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .custom
        transitioningDelegate = PopModalTransitioningDelegate()
    }
    
    var parameterValues: Observable<CommonChartParameters> {
        return viewModel!.parameterValues
    }
    
    func setChartParameters(chartParamters: CommonChartParameters) {
        viewModel = ChartParameterViewModel(initialParameters: chartParamters)
        dispose
            ++ viewModel!.closeTapped <~ parameterView.closeTapped
            ++ parameterView.chartParameters <~ viewModel!.chartParameters
            ++ parameterView.selectedDateRangeString <~ viewModel!.dateRangeString
            ++ parameterView.expandedRows <~ viewModel!.expandedParameters
            ++ viewModel!.parameterTappedAtIndex <~ parameterView.rowSelected
            ++ viewModel!.parameterValues <~ parameterView.parameterValues
    }
}
