//
//  DateRangeSelectionView.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/16/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit

class DateRangeSelectionView: UIView, ExpandableViewType, DrawableView {
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .NoStyle
        formatter.dateStyle = .ShortStyle
        return formatter
    }()
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var expandedView: UIView!
    @IBOutlet var selectedRangeLabel: UILabel!
    var selectedDateRange: CommonChartParameters.DateRangeParameter? = nil {
        didSet {
            guard let selectedDateRange = selectedDateRange else {
                return
            }
            updateLabelWithDateRange(selectedDateRange)
        }
    }
    
    var shapeLayer: CAShapeLayer!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        shapeLayer = addShapeLayer()
        addHairline(.Top)
    }
    
    private func updateLabelWithDateRange(dateRange: CommonChartParameters.DateRangeParameter) {
        let text: String
        switch dateRange {
        case .yearToDate:
            text = "ytd"
        case .monthToDate:
            text = "mtd"
        case .years(let years):
            text = years == 1 ? "1 year" : "\(years) years"
        case .months(let months):
            text = months == 1 ? "1 month" : "\(months) months"
        case .custom(let start, let end):
            let startText = dateFormatter.stringFromDate(start)
            let endText = dateFormatter.stringFromDate(end)
            text = "\(startText) - \(endText)"
        }
        selectedRangeLabel.text = text
    }
}
