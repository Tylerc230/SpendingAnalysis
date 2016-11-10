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
    let shrinkTransform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    let presenting: Bool
    init(presenting: Bool) {
        self.presenting = presenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let container = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        container.addSubview(fromViewController.view)
        container.addSubview(toViewController.view)

        if self.presenting {
            container.bringSubview(toFront: toViewController.view)
            self.showPresentAnimation(duration, presentedView: toViewController.view) { complete in
                transitionContext.completeTransition(true)
            }
        } else {
            container.bringSubview(toFront: fromViewController.view)
            self.showDismissAnimation(duration, presentedView: fromViewController.view) { complete in
                transitionContext.completeTransition(complete)
            }
        }
    }
    
    fileprivate func showPresentAnimation(_ duration: TimeInterval, presentedView: UIView, complete: @escaping (Bool) -> ()) {
        presentedView.transform = shrinkTransform
        UIView.animate(withDuration: duration, animations: {
            presentedView.transform = CGAffineTransform.identity
        }, completion: complete)
    }
    
    fileprivate func showDismissAnimation(_ duration: TimeInterval, presentedView: UIView, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: duration, animations: { 
            presentedView.transform = self.shrinkTransform
        }, completion: completion)
    }
}
