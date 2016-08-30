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
typealias ExpenseOverTimeResponse = DataFrameResponse<Int, Float>

enum DataFrameError: ErrorType {
    case invalidIndex
    case invalidColumn
}

struct DataFrameResponse<Index: Equatable, Data>: Mappable {
    var columns: [String]!
    var indicies: [Index]!
    var data: [[Data]]!
    init?(_ map: Map){}
    mutating func mapping(map: Map) {
        columns <- map["columns"]
        indicies <- map["index"]
        data <- map["data"]
    }
    
    func rowAtIndex(index: Index) throws -> [Data] {
        let rowOffset = try rowOffsetForIndex(index)
        return data[rowOffset]
    }
    
    func dataAtIndex(index: Index, column columnName: String) throws -> Data {
        let row = try rowAtIndex(index)
        let columnIdx = try columnOffset(columnName)
        return row[columnIdx]
    }
    
    private func columnOffset(columnName: String) throws -> Int {
        guard let columnOffset = columns.indexOf(columnName) else {
            throw DataFrameError.invalidColumn
        }
        return columnOffset
    }
    
    private func rowOffsetForIndex(index: Index) throws -> Int {
        guard let rowOffset = indicies.indexOf(index) else {
            throw DataFrameError.invalidIndex
        }
        return rowOffset
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
