//
//  SpendingAnalysisAPI.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 8/7/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import Moya

enum SpendingAnalysisAPI {
    case getTransactions
}

extension SpendingAnalysisAPI: TargetType {
    var baseURL: NSURL {
        return NSURL(string:"http://spending-analysis.us-west-2.elasticbeanstalk.com")!
    }
    
    var path: String {
        switch self {
        case getTransactions:
            return "/transactions"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case getTransactions:
            return .GET
        }
    }
    
    var parameters: [String: AnyObject]? {
        return nil
    }
    
    var sampleData: NSData {
        return NSData()
    }
    
    var multipartBody: [MultipartFormData]? {
        return nil
    }
    
}