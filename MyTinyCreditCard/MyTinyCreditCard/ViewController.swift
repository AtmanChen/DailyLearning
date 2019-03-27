//
//  ViewController.swift
//  MyTinyCreditCard
//
//  Created by 突突兔 on 2019/3/26.
//  Copyright © 2019 突突兔. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

