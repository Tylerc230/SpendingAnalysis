//
//  ResponseObjects.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 8/29/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import ObjectMapper
import Moya_ObjectMapper

let dateFormater = CustomDateFormatTransform(formatString: "yyyy-MM-dd")
typealias TransactionsResponse = PagedResponse<Transaction>

struct ExpenseOverTimeResponse: Mappable {
    struct Bin {
        var expensePerGroup: [String: Float]
    }
    init?(_ map: Map){}
    mutating func mapping(map: Map) {
        
    }
}

struct PagedResponse<Object: Mappable>: Mappable {
    var numResults: Int!
    var objects: [Object]!
    var page: Int!
    var totalPages: Int!
    init?(_ map: Map){}
    mutating func mapping(map: Map) {
        numResults <- map["num_results"]
        objects <- map ["objects"]
        page <- map["page"]
        totalPages <- map["total_pages"]
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
        date <- (map["date"], dateFormater)
    }
}
