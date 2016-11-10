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
import RxSugar

class DateRangeSelectionView: UIView, ExpandableViewType, DrawableView {
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var expandedView: UIView!
    @IBOutlet fileprivate var selectedRangeLabel: UILabel!
    @IBOutlet fileprivate var dynamicDateRangePicker: UISegmentedControl!
    @IBOutlet fileprivate var startDatePicker: UIDatePicker!
    @IBOutlet fileprivate var endDatePicker: UIDatePicker!
    fileprivate let disposeBag = DisposeBag()
    typealias DateRangeParameter = CommonChartParameters.DateRangeParameter
    fileprivate let dynamicDateRangeValues: [DateRangeParameter] = [.yearsAgo(0), .monthsAgo(0), .numYears(1), .numMonths(1), .yearsAgo(1), .monthsAgo(1)]
    var selectedDateRangeString: AnyObserver<String?> {
        return selectedRangeLabel.rx.text.asObserver()
    }
    
    var shapeLayer: CAShapeLayer!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        shapeLayer = addShapeLayer()
        addHairline(.top)
    }
    
    var dateRange: Observable<CommonChartParameters.DateRangeParameter> {
        let dynamicDateRange = dynamicDateRangePicker
            .rx.value
            .skip(1)//skip the initial value
            .map { index in
                return self.dynamicDateRangeValues[index]
        }
        
        let customDateRange = Observable.combineLatest(startDatePicker.rx.date, endDatePicker.rx.date) { (startDate, endDate)  in
            return DateRangeParameter.custom(startDate, endDate)
        }
        .skip(1)
        
        return Observable.from([dynamicDateRange, customDateRange]).merge()
    }
    
}
