//
//  ChartParameterViewController.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/12/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit
import RxSwift

class ChartParameterViewController: UIViewController {
    @IBOutlet private var closeButton: UIButton!
    var closeTapped: Observable<Void> {
        return closeButton.rx_tap.asObservable()
    }
}
