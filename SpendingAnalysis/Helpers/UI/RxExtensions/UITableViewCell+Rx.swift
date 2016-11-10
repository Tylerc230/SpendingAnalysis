//
//  UITableViewCell+Rx.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/19/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit
import RxSwift

extension UITableViewCell {
    var prepareForReuseObservable: Observable<Void> {
        let selector = #selector(UITableViewCell.prepareForReuse)
        return rx.sentMessage(selector).map { _ in Void() }
    }
}
