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
    
    func getExpensesOverTime(start start: NSDate? = nil, end: NSDate? = nil, binSize: BinSize? = nil) -> Observable<TransactionSet> {
        return provider
            .request(SpendingAnalysisAPI.getExpensesOverTime(start, end, binSize, nil))
            .mapObject(TransactionSet)
    }
    
    func getGroupedExpensesOverTime(start start: NSDate? = nil, end: NSDate? = nil, binSize: BinSize? = nil, includeTypes: GroupedTypes) -> Observable<GroupedTransactionSet> {
        return provider
            .request(SpendingAnalysisAPI.getExpensesOverTime(start, end, binSize, includeTypes))
            .mapObject(GroupedTransactionSet)
    }
}

