//
//  ViewController.swift
//  GraphLearning
//
//  Created by 突突兔 on 2019/1/25.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    fileprivate lazy var barView: BarChartView = {
        let chartView = BarChartView(frame: view.bounds)
        chartView.dataEntries = [
            BarEntry(score: 45, title: "Stark"),
            BarEntry(score: 35, title: "Thor"),
            BarEntry(score: 55, title: "Evans"),
            BarEntry(score: 3, title: "Vision"),
            BarEntry(score: 10, title: "Thanos")
        ]
        
        return chartView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(barView)
        
    }

    override func loadView() {
        super.loadView()
    }

}

