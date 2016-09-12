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

struct DataFrame<I: Transformable, Data where I: Equatable> {
    var columns: [String]!
    var indicies: [I]!
    var data: [[Data]]!
    init() {
        
    }
    
    init(columns: [String], data: [(I, [Data])]) {
        var newIndicies = [I]()
        var newRows = [[Data]]()
        data.forEach { (index, row) in
            newIndicies.append(index)
            newRows.append(row)
        }
        self.columns = columns
        self.indicies = newIndicies
        self.data = newRows
    }
    
    func rowAtIndex(index: I) throws -> [Data] {
        let rowOffset = try rowOffsetForIndex(index)
        return data[rowOffset]
    }
    
    func dataAtIndex(index: I, column columnName: String) throws -> Data {
        let row = try rowAtIndex(index)
        let columnIdx = try columnOffset(columnName)
        return row[columnIdx]
    }
    
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
    
    func mapDataFrame<NewIndexType, NewDataType>(@noescape transform: ((I, [Data])) -> (NewIndexType, [NewDataType]) ) -> DataFrame<NewIndexType, NewDataType> {
        let mappings = map (transform)
        return DataFrame<NewIndexType, NewDataType>(columns: columns, data: mappings)
    }
    
    func filterDataFrame(@noescape predicate: ((I, [Data]) -> Bool)) -> DataFrame {
        let mappings = filter(predicate)
        return DataFrame(columns: columns, data: mappings)
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
    typealias Index = Int
    var startIndex : Int { return 0 }
    var endIndex : Int { return indicies.count }
    
    subscript (index: Int) -> (I, [Data]) {
        return (indicies[index], data[index])
    }
    
}

