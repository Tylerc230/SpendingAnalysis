//
//  TransactionsByTimeViewController.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 8/5/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit
import RxSwift

class TransactionsByTimeViewController: UIViewController {
    let disposeBag = DisposeBag()
    var transactionsByTimeView: TransactionsByTimeView {
        return self.view as! TransactionsByTimeView
    }

}
