//
//  ExpandableTableViewCell.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/19/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import UIKit
import Cartography
import RxSwift

class ExpandableTableViewCell<View: UIView where View: ExpandableViewType>: UITableViewCell {
    var expandableView: View
    var disposeBag = DisposeBag()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        expandableView = View.loadFromNib()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addExpandableView(expandableView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func addExpandableView(view: View) {
        expandableView.removeFromSuperview()
        contentView.addSubview(view)
        addExpandableViewConstraints(view)
    }
    
    private func addExpandableViewConstraints(expandableView: View) {
        constrain(expandableView) { (view) in
            guard let superview = view.superview else {
                return
            }
            view.center == superview.center
            view.size == superview.size
        }
    }
}
