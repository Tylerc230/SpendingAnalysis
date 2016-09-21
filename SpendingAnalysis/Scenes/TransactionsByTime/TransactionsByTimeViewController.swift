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
    @IBOutlet private var parameterButton: UIButton!
    let disposeBag = DisposeBag()
    
    func setChartDataObservable(chartData: Observable<[String: TransactionSet]>) {
    }
    
    var parameterButtonTapped: Observable<Void> {
        return parameterButton.rx_tap.asObservable()
    }
    
    var transactionsByTimeView: TransactionsByTimeView {
        return self.view as! TransactionsByTimeView
    }
    
}
