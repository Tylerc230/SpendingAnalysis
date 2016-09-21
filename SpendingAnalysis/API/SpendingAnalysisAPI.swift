//
//  SpendingAnalysisAPI.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 8/7/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import Moya
typealias GroupedTypes = [String: [String]]
enum SpendingAnalysisAPI {
    case getTransactions(Int?)
    case getExpensesOverTime(NSDate?, NSDate?, BinSize?, GroupedTypes?)
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
    var baseURL: NSURL {
//        return NSURL(string:"http://spending-analysis.us-west-2.elasticbeanstalk.com")!
//        return NSURL(string:"http://localhost:5000")!
        return NSURL(string:"http://localhost.charlesproxy.com:5000")!
    }
    
    var path: String {
        switch self {
        case getTransactions:
            return "/api/statement_transaction"
        case getExpensesOverTime:
            return "/expenses_over_time"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case getTransactions, .getExpensesOverTime:
            return .GET
        }
    }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case .getTransactions(let page):
            guard let page = page else {
                return nil
            }
            return ["page": page]
        case .getExpensesOverTime(let start, let end, let binSize, let includeTypes):
            var params: [String: AnyObject] = [:]
            if let start = start {
                params["start"] = start
            }
            if let end = end {
                params["end"] = end
            }
            if let binSize = binSize {
                params["bin_size"] = binSize.parameterValue()
            }
            if let includeTypes = includeTypes {
                let JSONData = try! NSJSONSerialization.dataWithJSONObject(includeTypes, options: [])
                params["include_types"] = NSString(data: JSONData, encoding: NSUTF8StringEncoding)
            }
            return params
        }
    }
    
    var sampleData: NSData {
        return NSData()
    }
    
    var multipartBody: [MultipartFormData]? {
        return nil
    }
    
}
