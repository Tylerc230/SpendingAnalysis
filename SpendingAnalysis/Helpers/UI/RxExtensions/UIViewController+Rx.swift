//
//  UIViewController+Rx.swift
//  TBAppScaffold
//
//  Created by Tyler Casselman on 5/30/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension UIViewController {
    var prepareForSegue: Observable<UIViewController> {
        let selector = #selector(UIViewController.prepare(for:sender:))
        return rx.sentMessage(selector).map { parameters  in
            let segue = parameters.first as! UIStoryboardSegue
            return segue.destination
        }
    }
    
    var viewLoaded: Observable<UIViewController> {
        let selector = #selector(UIViewController.viewDidLoad)
        return rx.sentMessage(selector).mapTo(self).take(1)
    }
    
    var viewWillAppear: Observable<Void> {
        let selector = #selector(UIViewController.viewWillAppear(_:))
        return rx.sentMessage(selector).mapTo(Void())
    }
}
