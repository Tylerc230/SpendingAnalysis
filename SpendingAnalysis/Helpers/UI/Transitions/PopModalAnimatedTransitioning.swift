//
//  PopModalAnimatedTransitioning.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/13/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import Foundation
import UIKit
class PopModalAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        let dest = transitionContext.viewForKey(UITransitionContextToViewKey)!
        container?.addSubview(dest)
        dest.transform = CGAffineTransformMakeScale(0.01, 0.01)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            dest.transform = CGAffineTransformIdentity
        }) { (complete) in
            transitionContext.completeTransition(true)
        }
    }
}
