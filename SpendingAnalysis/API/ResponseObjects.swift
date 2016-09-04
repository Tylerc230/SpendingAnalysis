//
//  ResponseObjects.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 8/29/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import ObjectMapper
import Moya_ObjectMapper

let dateTransform = CustomDateFormatTransform(formatString: "yyyy-MM-dd")
let timestampTransform = DateTransform()
typealias TransactionsResponse = PagedResponse<Transaction>
typealias ExpenseOverTimeResponse = DataFrame<TimeGroupIndex, Float>

protocol IndexType: Equatable {
    associatedtype JSON
    static func transform() -> TransformOf<Self, JSON>?
}

extension IndexType {
    func transform() -> TransformOf<Self, JSON>? {
        return nil
    }
}

struct TimeGroupIndex: IndexType {
    typealias JSON = [AnyObject]
    typealias Object = TimeGroupIndex
    var date: NSDate!
    var group: String!
    static func transform() -> TransformOf<Object, JSON>? {
        func transformFromJSON(value: JSON?) -> Object? {
            guard
                let value = value,
                let timestamp = value[0] as? Double,
                let group = value[1] as? String else {
                    return nil
            }
            let date = NSDate(timeIntervalSince1970: timestamp)
            return TimeGroupIndex(date: date, group: group)
        }
        
        func transformToJSON(value: TimeGroupIndex?) -> [AnyObject]? {
            guard let index = value else {
                return nil
            }
            return [index.date.timeIntervalSince1970, index.group]
        }
        
        return TransformOf(fromJSON: transformFromJSON, toJSON: transformToJSON)
    }
}

func ==(lhs: TimeGroupIndex, rhs: TimeGroupIndex) -> Bool {
    return lhs.date.isEqual(rhs.date) && lhs.group == rhs.group
}

extension DataFrame: Mappable {
    init?(_ map: Map){
        self.init()
    }
    mutating func mapping(map: Map) {
        columns <- map["columns"]
        if let transform = Index.transform() {
            indicies <- (map["index"], transform)
        } else {
            indicies <- map["index"]
        }
        data <- map["data"]
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
        date <- (map["date"], dateTransform)
    }
}
