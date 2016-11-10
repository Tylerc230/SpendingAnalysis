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
typealias TransactionSet = DataFrame<Date, Float>
typealias GroupedTransactionSet = DataFrame<TimeGroupIndex, Float>

protocol Transformable {
    associatedtype T
    static func mapTransformable(_ map: Map) -> T
}

extension Date: Transformable {
    static func mapTransformable(_ map: Map) -> [Date] {
        var date: [Date]? = nil
        date <- (map, DateTransform())
        return date!
    }
}

extension TimeGroupIndex: Transformable {
    typealias JSON = [AnyObject]
    static func mapTransformable(_ map: Map) -> [TimeGroupIndex] {
        var timeGroupIndex: [TimeGroupIndex]? = nil
        timeGroupIndex <- (map, transform())
        return timeGroupIndex!
    }
    static func transform() -> TransformOf<TimeGroupIndex, JSON> {
        func transformFromJSON(_ json: JSON?) -> TimeGroupIndex? {
            guard
                let value = json,
                let timestamp = value[0] as? Double else {
                    fatalError("Failed to parse TimeGroupIndex: \(json)")
            }
            let date = Date(timeIntervalSince1970: timestamp)
            if let group = value[1] as? String {
                return TimeGroupIndex(date: date, group: group)
            } else {
                return TimeGroupIndex(date: date, group: "total")
            }
        }
        
        func transformToJSON(_ value: TimeGroupIndex?) -> JSON? {
            guard let index = value else {
                return nil
            }
            return [index.date.timeIntervalSince1970 as AnyObject, index.group as AnyObject]
        }
        
        return TransformOf(fromJSON: transformFromJSON, toJSON: transformToJSON)
    }
}

extension DataFrame: Mappable {
    init?(map: Map){
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
    init?(map: Map){}
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
    var date: Date!
    init?(map: Map) {}
    mutating func mapping(map: Map) {
        identifier <- map["id"]
        amount <- map["amount"]
        date <- (map["date"], dateTransform)
    }
}
