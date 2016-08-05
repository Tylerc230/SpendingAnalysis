//
//  MainMenuViewController.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 7/24/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import UIKit
import RxSwift

class MainMenuViewController: UIViewController {
    @IBOutlet private var transactionByTimeButton: UIButton!
    @IBOutlet private var reconcileButton: UIButton!
    let disposeBag = DisposeBag()
    var transactionByTimeButtonTapped: Observable<Void> {
        return transactionByTimeButton.rx_tap.asObservable()
    }
    
    var reconcileButtonTapped: Observable<Void> {
        return reconcileButton.rx_tap.asObservable()
    }
}
