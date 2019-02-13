//
//  Request.swift
//  RxEarthquakeLearning
//
//  Created by 突突兔 on 2019/1/28.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import Foundation


extension URLRequest {
    static let earthquakeSummary: URLRequest = {
        let url = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.geojson")!
        return URLRequest(url: url)
    }()
}
