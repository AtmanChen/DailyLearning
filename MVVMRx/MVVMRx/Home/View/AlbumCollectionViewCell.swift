//
//  AlbumCollectionViewCell.swift
//  MVVMRx
//
//  Created by 突突兔 on 2019/2/13.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    
    private lazy var backView: UIImageView = {
        let backView = UIImageView(frame: albumImageView.frame)
        backView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(backView)
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: albumImageView.topAnchor, constant: -10),
            backView.leadingAnchor.constraint(equalTo: albumImageView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: albumImageView.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: albumImageView.bottomAnchor)
            ])
        backView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        backView.alpha = 0.5
        contentView.bringSubviewToFront(albumImageView)
        return backView
    }()
    
    var withBackView: Bool! {
        didSet {
            backViewGenrator()
        }
    }
    
    var album: Album! {
        didSet {
            albumTitle.text = album.name
            albumArtist.text = album.artist
            albumImageView.loadImage(fromURL: album.albumArtWork)
        }
    }
    
    private func backViewGenrator() {
        backView.loadImage(fromURL: album.albumArtWork)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = UIImage()
        backView.image = UIImage()
    }

}
