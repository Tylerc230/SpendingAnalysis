//
//  ChartParameterViewModel.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/12/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import TBAppScaffold
import RxSwift

struct ChartParameterViewModel: ViewModel {
    let closeTapped = PublishSubject<Void>()
    var chartParameters: Observable<CommonChartParameters> {
        return Observable<CommonChartParameters>.just(CommonChartParameters(dateRange: .yearToDate, transactionTypes: []))
    }
    var events: Observable<TransitionEvent> {
        return closeTapped.map { .chartParametersDismissed }
    }
}