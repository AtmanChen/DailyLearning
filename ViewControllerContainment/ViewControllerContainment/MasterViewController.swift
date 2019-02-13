//
//  ViewController.swift
//  ViewControllerContainment
//
//  Created by 突突兔 on 2019/2/13.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit

final class MasterViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private lazy var summaryViewController: SummaryViewController = {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        add(asChildViewController: vc)
        return vc
    }()
    
    private lazy var sessionsViewController: SessionsViewController = {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "SessionsViewController") as! SessionsViewController
        add(asChildViewController: vc)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        setupSegmentControl()
        updateView()
    }
    
    private func setupSegmentControl() {
        segmentControl.removeAllSegments()
        segmentControl.insertSegment(withTitle: "Summary", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "Sessions", at: 1, animated: false)
        segmentControl.addTarget(self, action: #selector(selectionDidChanged(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
    }

    @objc
    private func selectionDidChanged(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private func updateView() {
        if segmentControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: sessionsViewController)
            add(asChildViewController: summaryViewController)
        } else {
            remove(asChildViewController: summaryViewController)
            add(asChildViewController: sessionsViewController)
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.frame
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}

