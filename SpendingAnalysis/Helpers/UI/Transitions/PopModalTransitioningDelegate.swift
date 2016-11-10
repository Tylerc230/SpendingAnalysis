//
//  PopModalTransitioningDelegate.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/12/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit

class PopModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopModalAnimatedTransitioning(presenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopModalAnimatedTransitioning(presenting: false)
    }
}
