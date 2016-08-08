//
//  NetworkInterface.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 8/7/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import Moya
import RxSwift
import ObjectMapper
import Moya_ObjectMapper

struct NetworkInterface {
    let provider = RxMoyaProvider<SpendingAnalysisAPI>()
    func getTransactions() -> Observable<[Transaction]> {
        return provider.request(.getTransactions).mapArray(Transaction).debug("transactions")
    }
}

struct Transaction: Mappable {
    var identifier: Int!
    var amount: Double!
    var date: NSDate!
    init?(_ map: Map) {}
    mutating func mapping(map: Map) {
        identifier <- map["id"]
        amount <- map["amount"]
        date <- map["date"]
    }
}