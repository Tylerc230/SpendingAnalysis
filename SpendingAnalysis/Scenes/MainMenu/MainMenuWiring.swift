//
//  MainMenuWiring.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 7/24/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import TBAppScaffold
import RxSugar

struct MainMenuWiring: Wiring {
    let viewModel = MainMenuViewModel()
    func wire(_ mainMenuView: MainMenuViewController) {
        mainMenuView.disposeBag
            ++ viewModel.transactionByTimeTapped <~ mainMenuView.transactionByTimeButtonTapped
            ++ viewModel.reconcileTapped <~ mainMenuView.reconcileButtonTapped
    }
}
