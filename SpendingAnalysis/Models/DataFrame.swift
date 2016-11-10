//
//  DataFrame.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/4/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

enum DataFrameError: Error {
    case invalidIndex
    case invalidColumn
}

struct DataFrame<I: Transformable, Data> where I: Equatable {
    var columns: [String]!
    var indicies: [I]!
    var data: [[Data]]!
    init() {
        
    }
    
    init(columns: [String], data: [(I, [Data])]) {
        self.columns = columns
        self.indicies = data.map { $0.0 }
        self.data = data.map { $0.1 }
    }
    
    func rowAtIndex(_ index: I) throws -> [Data] {
        let rowOffset = try rowOffsetForIndex(index)
        return data[rowOffset]
    }
    
    func dataAtIndex(_ index: I, column columnName: String) throws -> Data {
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
    
    func mapDataFrame<NewIndexType, NewDataType>(_ transform: ((I, [Data])) -> (NewIndexType, [NewDataType]) ) -> DataFrame<NewIndexType, NewDataType> {
        let mappings = map (transform)
        return DataFrame<NewIndexType, NewDataType>(columns: columns, data: mappings)
    }
    
    func filterDataFrame(_ predicate: ((I, [Data]) -> Bool)) -> DataFrame {
        let mappings = filter(predicate)
        return DataFrame(columns: columns, data: mappings)
    }
    
    fileprivate func columnOffset(_ columnName: String) throws -> Int {
        guard let columnOffset = columns.index(of: columnName) else {
            throw DataFrameError.invalidColumn
        }
        return columnOffset
    }
    
    fileprivate func rowOffsetForIndex(_ index: I) throws -> Int {
        guard let rowOffset = indicies.index(of: index) else {
            throw DataFrameError.invalidIndex
        }
        return rowOffset
    }
}

extension DataFrame: Collection {
    public func index(after i: Int) -> Int {
        return indicies.index(after: i)
    }

    typealias Index = Int
    var startIndex : Int { return 0 }
    var endIndex : Int { return indicies.count }
    
    subscript (index: Int) -> (I, [Data]) {
        return (indicies[index], data[index])
    }
    
}

