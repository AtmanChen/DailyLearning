//
//  SceneCoordinator.swift
//  MyPapr
//
//  Created by 突突兔 on 2019/2/16.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


final class SceneCoordinator: NSObject, SceneCoordinatorType {
    
    static var shared: SceneCoordinator!
    
    
    fileprivate var window: UIWindow
    fileprivate var currentViewController: UIViewController {
        didSet {
            currentViewController.navigationController?.delegate = self
            currentViewController.tabBarController?.delegate = self
        }
    }
    
    
    
    
    
    
    required init(window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController!
    }
    
    @discardableResult
    func transition(to scene: TargetScene) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        switch scene.transition {
        case let .tabBar(tabBarController):
            guard let _ = tabBarController.selectedViewController else {
                fatalError("Selected View Controller doesn't exist")
            }
            window.rootViewController = tabBarController
        }
        return subject
            .asObservable()
            .take(1)
    }
    
    @discardableResult
    func pop(animated: Bool) -> Observable<Void> {
        return Observable.just(())
    }
    
    
}

extension SceneCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
    }
}

extension SceneCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}
