//
//  TransactionsByTimeViewController.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 8/5/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit
import RxSwift
import Charts
import RxSugar

class TransactionsByTimeViewController: UIViewController {
    @IBOutlet fileprivate var parameterButton: UIButton!
    let disposeBag = DisposeBag()
    let viewModel = TransactionsByTimeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        disposeBag
            ++ viewModel.queryForCurrentTransactions <~ self.viewWillAppear.map { CommonChartParameters.defaultParameters }
            ++ viewModel.showParametersView <~ parameterButtonTapped
            ++ transactionsByTimeView.lineChartData <~ viewModel.lineChartData()
            ++ transactionsByTimeView.xAxisLabels <~ viewModel.xAxisLabels().debug()
    }
    func setChartDataObservable(_ chartData: Observable<[String: TransactionSet]>) {
    }
    
    var parameterButtonTapped: Observable<Void> {
        return parameterButton.rx.tap.asObservable()
    }
    
    var transactionsByTimeView: TransactionsByTimeView {
        return self.view as! TransactionsByTimeView
    }
    
}
