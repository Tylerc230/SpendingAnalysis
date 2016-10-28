//
//  DateRangeSelectionView.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/16/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DateRangeSelectionView: UIView, ExpandableViewType, DrawableView {
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var expandedView: UIView!
    @IBOutlet var selectedRangeLabel: UILabel!
    @IBOutlet var dynamicDateRangePicker: UISegmentedControl!
    @IBOutlet var startDatePicker: UIDatePicker!
    @IBOutlet var endDatePicker: UIDatePicker!
    let disposeBag = DisposeBag()
    let dynamicDateRangeValues: [DateRange] = [.yearsAgo(0), .monthsAgo(0), .numYears(1), .numMonths(1), .yearsAgo(1), .monthsAgo(1)]
    enum DateRange {
        case numYears(Int), numMonths(Int), yearsAgo(Int), monthsAgo(Int), custom(NSDate, NSDate)
    }
    var selectedDateRange: String? = nil {
        didSet {
            selectedRangeLabel.text = selectedDateRange
        }
    }
    
    var shapeLayer: CAShapeLayer!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        shapeLayer = addShapeLayer()
        addHairline(.Top)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupRx()
    }
    
    private func setupRx() {
        let dynamicDateRange = dynamicDateRangePicker
            .rx_value
            .map { index in
                return self.dynamicDateRangeValues[index]
        }
        
        let customDateRange = Observable.combineLatest(startDatePicker.rx_date, endDatePicker.rx_date) { (startDate, endDate)  in
            return DateRange.custom(startDate, endDate)
        }
        
        let final = [dynamicDateRange, customDateRange].toObservable().merge()
        final.subscribeNext { (range) in
            print(range)
        }
        .addDisposableTo(disposeBag)
    }
    
}
