//
//  SceneCoordinatorType.swift
//  MyPapr
//
//  Created by 突突兔 on 2019/2/16.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit
import RxSwift


protocol SceneCoordinatorType {
    init(window: UIWindow)
    
    @discardableResult func transition(to scene: TargetScene) -> Observable<Void>
    @discardableResult func pop(animated: Bool) -> Observable<Void>
}
