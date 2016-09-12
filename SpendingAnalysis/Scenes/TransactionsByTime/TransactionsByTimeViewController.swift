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
    let disposeBag = DisposeBag()
    
    func setChartDataObservable(chartData: Observable<[String: TransactionSet]>) {
        disposeBag
            ++ transactionsByTimeView.lineChartData <~ chartData
    }
    
    private var transactionsByTimeView: TransactionsByTimeView {
        return self.view as! TransactionsByTimeView
    }
    
}
