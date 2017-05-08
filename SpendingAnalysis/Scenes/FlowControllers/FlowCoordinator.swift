//
//  FlowCoordinator.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 3/23/17.
//  Copyright © 2017 13bit consulting. All rights reserved.
//
import UIKit
import RxSwift

protocol FlowCoordinator {
    func start()
}

protocol NavFlowCoordinator: FlowCoordinator {
    init(push: AnyObserver<UIViewController>, present: AnyObserver<UIViewController>, dismiss: AnyObserver<Void>)
}

extension NavFlowCoordinator {
    init(navController: UINavigationController) {
        let present = AnyObserver<UIViewController>() { event in
            if case let .next(viewController) = event {
                navController.present(viewController, animated: true, completion: nil)
            }
        }
        let dismiss = AnyObserver<Void> { event in
            if case .next = event {
                navController.dismiss(animated: true, completion: nil)
            }
        }
        
        let push = AnyObserver<UIViewController> { event in
            if case .next(let viewController) = event {
                navController.pushViewController(viewController, animated: true)
            }
        }
        self.init(push: push, present: present, dismiss: dismiss)
    }
}
