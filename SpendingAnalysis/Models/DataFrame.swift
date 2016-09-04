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

struct DataFrame<Index: IndexType, Data> {
    var columns: [String]!
    var indicies: [Index]!
    var data: [[Data]]!
    subscript(index: Index, column: String) -> Data {
        do{
            return try dataAtIndex(index, column: column)
        }
        catch(let error) {
            fatalError("DataFrame subscript error: \(error)")
        }
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

