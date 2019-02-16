//
//  BaseNavigator.swift
//  MVVMTest
//
//  Created by 突突兔 on 2019/2/15.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit

class BaseNavigator {
    
    private let navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

