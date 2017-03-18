//
//  MainMenuViewModel.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 7/24/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import RxSwift
import RxSwiftExt

struct MainMenuViewModel {
    let transactionByTimeTapped = PublishSubject<Void>()
    let reconcileTapped = PublishSubject<Void>()
}
