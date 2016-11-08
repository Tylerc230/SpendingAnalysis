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
    @IBOutlet private var selectedRangeLabel: UILabel!
    @IBOutlet private var dynamicDateRangePicker: UISegmentedControl!
    @IBOutlet private var startDatePicker: UIDatePicker!
    @IBOutlet private var endDatePicker: UIDatePicker!
    private let disposeBag = DisposeBag()
    typealias DateRangeParameter = CommonChartParameters.DateRangeParameter
    private let dynamicDateRangeValues: [DateRangeParameter] = [.yearsAgo(0), .monthsAgo(0), .numYears(1), .numMonths(1), .yearsAgo(1), .monthsAgo(1)]
    var selectedDateRangeString: AnyObserver<String> {
        return selectedRangeLabel.rx_text
    }
    
    var shapeLayer: CAShapeLayer!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        shapeLayer = addShapeLayer()
        addHairline(.Top)
    }
    
    var dateRange: Observable<CommonChartParameters.DateRangeParameter> {
        let dynamicDateRange = dynamicDateRangePicker
            .rx_value
            .skip(1)//skip the initial value
            .map { index in
                return self.dynamicDateRangeValues[index]
        }
        
        let customDateRange = Observable.combineLatest(startDatePicker.rx_date, endDatePicker.rx_date) { (startDate, endDate)  in
            return DateRangeParameter.custom(startDate, endDate)
        }
        .skip(1)
        
        return [dynamicDateRange, customDateRange].toObservable().merge()
    }
    
}
