//
//  ExpandableViewType.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/16/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ExpandableViewType {
    associatedtype ExpandedView: UIView
    var stackView: UIStackView! { get }
    var expandedView: ExpandedView! { get }
    func setExpanded(_ expanded: Bool)
    func expand()
    func collapse()
}

extension ExpandableViewType where Self: UIView {
    var expandedObserver: AnyObserver<Bool> {
        return AnyObserver<Bool> { [unowned self] event in
            guard case .next(let next) = event else {
                return
            }
            print("set expanded")
            self.setExpanded(next)
        }
    }
    
    func setExpanded(_ expanded: Bool) {
        if expanded {
            expand()
        } else {
            collapse()
        }
    }
    
    func expand() {
        guard !stackView.arrangedSubviews.contains(expandedView) else {
            return
        }
        stackView.addArrangedSubview(expandedView)
    }
    
    func collapse() {
        guard stackView.arrangedSubviews.contains(expandedView) else {
            return
        }
        stackView.removeArrangedSubview(expandedView)
    }
}
