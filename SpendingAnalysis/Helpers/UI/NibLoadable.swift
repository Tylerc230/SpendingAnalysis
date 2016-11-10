//
//  NibLoadable.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/19/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    static func loadFromNib(_ owner: AnyObject? = nil) -> Self {
        return loadFromNibHelper(owner)
    }
    
    fileprivate static func loadFromNibHelper<T>(_ owner: AnyObject?) -> T {
        let nibName = String(describing: self).components(separatedBy: ".").last!
        let nib = Bundle.main.loadNibNamed(nibName, owner: owner, options: nil)
        return nib!.filter { $0 is UIView }.first as! T
    }
}
