//
//  EarthquakeTableViewCell.swift
//  RxEarthquakeLearning
//
//  Created by 突突兔 on 2019/1/28.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit

class EarthquakeTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var magnitudeImageView: UIImageView!
    @IBOutlet weak var magnitudeLabel: UILabel!
    

    func configure(viewModel: EarthquakeCellViewModel) {
        locationLabel.text = viewModel.location
        timestampLabel.text = viewModel.timestamp
        magnitudeLabel.text = viewModel.magnitude
        magnitudeImageView.image = viewModel.magnitudeImage
    }
}
