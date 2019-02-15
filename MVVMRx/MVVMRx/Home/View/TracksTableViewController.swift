//
//  TracksTableViewController.swift
//  MVVMRx
//
//  Created by 突突兔 on 2019/2/13.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TracksTableViewController: UIViewController {

    @IBOutlet weak var trackTableView: UITableView!
    
    var tracks = PublishSubject<[Track]>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackTableView.tableFooterView = UIView()
        trackTableView.register(UINib(nibName: "TrackTableViewCell", bundle: nil), forCellReuseIdentifier: "TrackTableViewCell")
        setupBindings()
        trackTableView.backgroundColor = .clear
    }
    
    private func setupBindings() {
        
        tracks
            .bind(to: trackTableView.rx.items(cellIdentifier: "TrackTableViewCell", cellType: TrackTableViewCell.self)) { row, track, cell in
                cell.track = track
            }
            .disposed(by: disposeBag)
        
        trackTableView.rx.willDisplayCell.asObservable()
            .subscribe(onNext: { (cell, indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    

}
