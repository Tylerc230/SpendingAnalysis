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
    static func loadFromNib(owner: AnyObject? = nil) -> Self {
        return loadFromNibHelper(owner)
    }
    
    private static func loadFromNibHelper<T>(owner: AnyObject?) -> T {
        let nibName = String(self).componentsSeparatedByString(".").last!
        let nib = NSBundle.mainBundle().loadNibNamed(nibName, owner: owner, options: nil)
        return nib.filter { $0 is UIView }.first as! T
    }
}
