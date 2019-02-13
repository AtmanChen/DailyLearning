//
//  EarthquakeCellViewModel.swift
//  RxEarthquakeLearning
//
//  Created by 突突兔 on 2019/1/28.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxSwiftExt

struct EarthquakeCellViewModel {
    let location: String
    let timestamp: String
    let magnitude: String
    let magnitudeImage: UIImage
    
    init(_ earthquake: Earthquake) {
        location = earthquake.name
        timestamp = timestampFormatter.string(from: earthquake.timestamp)
        magnitude = magnitudeFormatter.string(from: NSNumber(value: earthquake.magnitude)) ?? ""
        switch earthquake.magnitude {
        case 0..<2:
            magnitudeImage = UIImage()
        case 2..<3:
            magnitudeImage = UIImage(named: "2.0")!
        case 3..<4:
            magnitudeImage = UIImage(named: "3.0")!
        case 4..<5:
            magnitudeImage = UIImage(named: "4.0")!
        default:
            magnitudeImage = UIImage(named: "5.0")!
        }
        
    }
}


private
let timestampFormatter: DateFormatter = {
    let timestampFormatter = DateFormatter()
    
    timestampFormatter.dateStyle = .medium
    timestampFormatter.timeStyle = .medium
    
    return timestampFormatter
}()

private
let magnitudeFormatter: NumberFormatter = {
    let magnitudeFormatter = NumberFormatter()
    
    magnitudeFormatter.numberStyle = .decimal
    magnitudeFormatter.maximumFractionDigits = 1
    magnitudeFormatter.minimumFractionDigits = 1
    
    return magnitudeFormatter
}()
