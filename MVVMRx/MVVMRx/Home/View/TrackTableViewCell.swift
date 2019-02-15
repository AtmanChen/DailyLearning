//
//  TrackTableViewCell.swift
//  MVVMRx
//
//  Created by 突突兔 on 2019/2/13.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackArtist: UILabel!
    
    var track: Track! {
        didSet {
            trackImageView.layer.cornerRadius = 3
            trackImageView.clipsToBounds = true
            trackImageView.loadImage(fromURL: track.trackArtWork)
            trackTitle.text = track.name
            trackArtist.text = track.artist
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = UIImage()
    }
    
}
