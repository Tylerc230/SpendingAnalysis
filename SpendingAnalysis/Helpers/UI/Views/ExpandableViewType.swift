//
//  ExpandableViewType.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/16/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit
protocol ExpandableViewType {
    associatedtype ExpandedView: UIView
    var stackView: UIStackView! { get }
    var expandedView: ExpandedView! { get }
    func expand()
    func contract()
}

extension ExpandableViewType {
    func expand() {
        guard !stackView.arrangedSubviews.contains(expandedView) else {
            return
        }
        stackView.addArrangedSubview(expandedView)
    }
    
    func contract() {
        guard stackView.arrangedSubviews.contains(expandedView) else {
            return
        }
        stackView.removeArrangedSubview(expandedView)
    }
}
