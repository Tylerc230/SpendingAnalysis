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
    let parameterButtonTapped = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    var viewModel: TransactionsByTimeViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else {
            return
        }
        disposeBag
            ++ transactionsByTimeView.lineChartData <~ viewModel.lineChartData
            ++ transactionsByTimeView.xAxisLabels <~ viewModel.xAxisLabels
            ++ parameterButtonTapped <~ parameterButton.rx.tap
    }
    
    var transactionsByTimeView: TransactionsByTimeView {
        return self.view as! TransactionsByTimeView
    }
    
}
