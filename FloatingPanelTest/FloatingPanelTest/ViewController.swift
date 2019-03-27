//
//  ViewController.swift
//  FloatingPanelTest
//
//  Created by 突突兔 on 2019/2/18.
//  Copyright © 2019 突突兔. All rights reserved.
//

import UIKit
import FloatingPanel

class ViewController: UIViewController {

    var fpc: FloatingPanelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fpc = FloatingPanelController()
        fpc.delegate = self
        
        let contentViewController = UIViewController()
        let label: UILabel = {
            $0.text = "Panel Test"
            $0.font = UIFont.preferredFont(forTextStyle: .headline)
            $0.textColor = .black
            return $0
        }(UILabel())
        contentViewController.view.backgroundColor = UIColor.random()
        contentViewController.view.addSubview(label)
        label.bounds = CGRect(x: 0, y: 0, width: 200, height: 30)
        label.center = CGPoint(x: contentViewController.view.center.x, y: contentViewController.view.frame.origin.y + 60)
        fpc.set(contentViewController: contentViewController)
        fpc.addPanel(toParent: self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fpc.removePanelFromParent(animated: true)
    }


}

extension ViewController: FloatingPanelControllerDelegate {
    
}

