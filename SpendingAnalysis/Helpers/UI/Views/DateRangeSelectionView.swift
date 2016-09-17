//
//  DateRangeSelectionView.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/16/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit

class DateRangeSelectionView: UIView, ExpandableViewType, DrawableView {
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var expandedView: UIView!
    var shapeLayer: CAShapeLayer!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        shapeLayer = addShapeLayer()
        addHairline(.Top)
    }
}
