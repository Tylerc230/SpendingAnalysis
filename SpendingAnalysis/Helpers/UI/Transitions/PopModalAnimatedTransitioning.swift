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
    let shrinkTransform = CGAffineTransformMakeScale(0.01, 0.01)
    let presenting: Bool
    init(presenting: Bool) {
        self.presenting = presenting
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(transitionContext)
        let container = transitionContext.containerView()
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        container.addSubview(fromViewController.view)
        container.addSubview(toViewController.view)

        if self.presenting {
            container.bringSubviewToFront(toViewController.view)
            self.showPresentAnimation(duration, presentedView: toViewController.view) { complete in
                transitionContext.completeTransition(true)
            }
        } else {
            container.bringSubviewToFront(fromViewController.view)
            self.showDismissAnimation(duration, presentedView: fromViewController.view) { complete in
                transitionContext.completeTransition(complete)
            }
        }
    }
    
    private func showPresentAnimation(duration: NSTimeInterval, presentedView: UIView, complete: (Bool) -> ()) {
        presentedView.transform = shrinkTransform
        UIView.animateWithDuration(duration, animations: {
            presentedView.transform = CGAffineTransformIdentity
        }, completion: complete)
    }
    
    private func showDismissAnimation(duration: NSTimeInterval, presentedView: UIView, completion: (Bool) -> ()) {
        UIView.animateWithDuration(duration, animations: { 
            presentedView.transform = self.shrinkTransform
        }, completion: completion)
    }
}
