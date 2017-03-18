//
//  MainMenuViewController.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 7/24/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import UIKit
import RxSwift
import RxSugar

class MainMenuViewController: UIViewController {
    @IBOutlet fileprivate var transactionByTimeButton: UIButton!
    @IBOutlet fileprivate var reconcileButton: UIButton!
    let viewModel = MainMenuViewModel()
    let disposeBag = DisposeBag()
    var transactionByTimeButtonTapped: Observable<Void> {
        return transactionByTimeButton.rx.tap.asObservable()
    }
    
    var reconcileButtonTapped: Observable<Void> {
        return reconcileButton.rx.tap.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disposeBag
            ++ viewModel.transactionByTimeTapped <~ transactionByTimeButtonTapped
            ++ viewModel.reconcileTapped <~ reconcileButtonTapped
    }
}
