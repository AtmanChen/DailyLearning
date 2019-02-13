//
//  SessionsViewController.swift
//  ViewControllerContainment
//
//  Created by 突突兔 on 2019/2/13.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit

class SessionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(SessionsViewController.description()) will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(SessionsViewController.description()) will disappear")
    }

}
