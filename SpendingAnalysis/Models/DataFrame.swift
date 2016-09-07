//
//  DataFrame.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/4/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

enum DataFrameError: ErrorType {
    case invalidIndex
    case invalidColumn
}

struct DataFrame<I: ForwardIndexType , Data where I: Transformable> {
    var columns: [String]!
    var indicies: [I]!
    var data: [[Data]]!
    func rowAtIndex(index: I) throws -> [Data] {
        let rowOffset = try rowOffsetForIndex(index)
        return data[rowOffset]
    }
    
    func dataAtIndex(index: I, column columnName: String) throws -> Data {
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
    
    private func rowOffsetForIndex(index: I) throws -> Int {
        guard let rowOffset = indicies.indexOf(index) else {
            throw DataFrameError.invalidIndex
        }
        return rowOffset
    }
}

extension DataFrame: CollectionType {
    typealias Index = I
    var startIndex : I { return indicies.first! }
    var endIndex : I { return indicies.last! }
    
    subscript (index: I) -> [Data] {
        do {
            return try rowAtIndex(index)
        }
        catch(let error) {
            fatalError("\(error)")
        }
    }
    
    subscript(index: I, column: String) -> Data {
        do{
            return try dataAtIndex(index, column: column)
        }
        catch(let error) {
            fatalError("DataFrame subscript error: \(error)")
        }
    }
}

