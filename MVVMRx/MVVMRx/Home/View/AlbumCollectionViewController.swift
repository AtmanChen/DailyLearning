//
//  AlbumCollectionViewController.swift
//  MVVMRx
//
//  Created by 突突兔 on 2019/2/13.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumCollectionViewController: UIViewController {

    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    var albums = PublishSubject<[Album]>()
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        albumCollectionView.backgroundColor = .clear
    }
    
    private func setupBindings() {
        albumCollectionView.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCollectionViewCell")
        
        albums
            .bind(to: albumCollectionView.rx.items(cellIdentifier: "AlbumCollectionViewCell", cellType: AlbumCollectionViewCell.self)) { (item, album, cell) in
                cell.album = album
                cell.withBackView = true
            }
            .disposed(by: disposeBag)
        
        albumCollectionView.rx.willDisplayCell.asObservable()
            .subscribe(onNext: { (cell, indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })
            .disposed(by: disposeBag)
    }

}
