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
typealias TransactionSet = DataFrame<NSDate, Float>
typealias GroupedTransactionSet = DataFrame<TimeGroupIndex, Float>

protocol Transformable {
    associatedtype T
    static func mapTransformable(map: Map) -> T
}

extension NSDate: Transformable {
    static func mapTransformable(map: Map) -> [NSDate] {
        var date: [NSDate]? = nil
        date <- (map, DateTransform())
        return date!
    }
}

extension TimeGroupIndex: Transformable {
    typealias JSON = [AnyObject]
    static func mapTransformable(map: Map) -> [TimeGroupIndex] {
        var timeGroupIndex: [TimeGroupIndex]? = nil
        timeGroupIndex <- (map, transform())
        return timeGroupIndex!
    }
    static func transform() -> TransformOf<TimeGroupIndex, JSON> {
        func transformFromJSON(json: JSON?) -> TimeGroupIndex? {
            guard
                let value = json,
                let timestamp = value[0] as? Double else {
                    fatalError("Failed to parse TimeGroupIndex: \(json)")
            }
            let date = NSDate(timeIntervalSince1970: timestamp)
            if let group = value[1] as? String {
                return TimeGroupIndex(date: date, group: group)
            } else {
                return TimeGroupIndex(date: date, group: "total")
            }
        }
        
        func transformToJSON(value: TimeGroupIndex?) -> JSON? {
            guard let index = value else {
                return nil
            }
            return [index.date.timeIntervalSince1970, index.group]
        }
        
        return TransformOf(fromJSON: transformFromJSON, toJSON: transformToJSON)
    }
}

extension DataFrame: Mappable {
    init?(_ map: Map){
        self.init()
    }
    mutating func mapping(map: Map) {
        columns <- map["columns"]
        data <- map["data"]
        indicies = I.mapTransformable(map["index"]) as! [I]
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
