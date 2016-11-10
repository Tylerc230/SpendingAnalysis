//
//  SpendingAnalysisAPI.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 8/7/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import Moya
let apiDateFormat = "yyyy-MM-dd"
let apiDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = apiDateFormat
    return dateFormatter
}()
typealias GroupedTypes = [String: [String]]
enum SpendingAnalysisAPI {
    case getTransactions(Int?)
    case getExpensesOverTime(Date?, Date?, BinSize?, GroupedTypes?)
}

enum BinSize {
    case days(Int)
    case weeks(Int)
    case months(Int)
    case years(Int)
    func parameterValue() -> String {
        switch self {
        case .days(let num):
            return "\(num)D"
        case .weeks(let num):
            return "\(num)W"
        case .months(let num):
            return "\(num)M"
        case .years(let num):
            return "\(num)Y"
        }
    }
}

extension SpendingAnalysisAPI: TargetType {
    public var task: Task {
        return .request
    }

    var baseURL: URL {
//        return URL(string:"http://spending-analysis.us-west-2.elasticbeanstalk.com")!
//        return URL(string:"http://localhost:5000")!
        return URL(string:"http://localhost.charlesproxy.com:5000")!
    }
    
    var path: String {
        switch self {
        case .getTransactions:
            return "/api/statement_transaction"
        case .getExpensesOverTime:
            return "/expenses_over_time"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTransactions, .getExpensesOverTime:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getTransactions(let page):
            guard let page = page else {
                return nil
            }
            return ["page": page]
        case .getExpensesOverTime(let start, let end, let binSize, let includeTypes):
            var params: [String: Any] = [:]
            if let start = start {
                params["start"] = apiDateFormatter.string(from: start)
            }
            if let end = end {
                params["end"] = apiDateFormatter.string(from: end)
            }
            if let binSize = binSize {
                params["bin_size"] = binSize.parameterValue()
            }
            if let includeTypes = includeTypes {
                let JSONData = try! JSONSerialization.data(withJSONObject: includeTypes, options: [])
                params["include_types"] = NSString(data: JSONData, encoding: String.Encoding.utf8.rawValue)
            }
            return params
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var multipartBody: [MultipartFormData]? {
        return nil
    }
    
}
