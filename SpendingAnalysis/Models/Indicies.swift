//
//  Indicies.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/4/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import Foundation
struct TimeGroupIndex {
    let date: NSDate
    let group: String
    var next: (() -> TimeGroupIndex)? = nil
    
    init(date: NSDate, group: String) {
        self.date = date
        self.group = group
    }
}

extension TimeGroupIndex: ForwardIndexType {
    func successor() -> TimeGroupIndex {
        return next!()
    }
}

func ==(lhs: TimeGroupIndex, rhs: TimeGroupIndex) -> Bool {
    return lhs.date.isEqual(rhs.date) && lhs.group == rhs.group
}
