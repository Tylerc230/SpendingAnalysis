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
    let menuItemSelected: Observable<MenuItem>
    enum MenuItem {
        case transactionsByTime, reconcile
    }
    init(transactionByTimeTapped: Observable<Void>, reconcileTapped: Observable<Void>) {
        menuItemSelected = Observable.from([transactionByTimeTapped.map { MenuItem.transactionsByTime }, reconcileTapped.map { MenuItem.reconcile }]).merge()
    }
}
