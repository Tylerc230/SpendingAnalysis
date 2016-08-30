//
//  NetworkInterface.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 8/7/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import Moya
import RxSwift


struct NetworkInterface {
    let provider = RxMoyaProvider<SpendingAnalysisAPI>()
    
    func getTransactions(page: Int? = nil) -> Observable<TransactionsResponse> {
        return provider
            .request(SpendingAnalysisAPI.getTransactions(page))
            .mapObject(TransactionsResponse)
    }
    
    func getExpensesOverTime() -> Observable<ExpenseOverTimeResponse> {
        return provider
        .request(SpendingAnalysisAPI.getExpensesOverTime)
        .mapObject(ExpenseOverTimeResponse)
    }
}

