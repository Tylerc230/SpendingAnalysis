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
    let transactionByTimeTapped = PublishSubject<Void>()
    let reconcileTapped = PublishSubject<Void>()
    var viewModel: MainMenuViewModel?
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        disposeBag
            ++ transactionByTimeTapped <~ transactionByTimeButton.rx.tap
            ++ reconcileTapped <~ reconcileButton.rx.tap
    }
}
