//
//  ViewController.swift
//  MVVMRx
//
//  Created by 突突兔 on 2019/2/13.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class HomeViewController: UIViewController {

    
    @IBOutlet weak var trackVCView: UIView!
    @IBOutlet weak var albumVCView: UIView!
    
    private lazy var albumCollectionVC: AlbumCollectionViewController = {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let albumVc = sb.instantiateViewController(withIdentifier: "AlbumCollectionViewController") as! AlbumCollectionViewController
        add(asChildViewController: albumVc, to: albumVCView)
        return albumVc
    }()
    
    private lazy var trackTableVC: TracksTableViewController = {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let trackVc = sb.instantiateViewController(withIdentifier: "TracksTableViewController") as! TracksTableViewController
        add(asChildViewController: trackVc, to: trackVCView)
        return trackVc
    }()
    
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addBlurArea(area: view.frame, style: .dark)
        setupBindings()
        viewModel.requestData()
    }
    
    private func setupBindings() {
        viewModel
            .albums
            .observeOn(MainScheduler.instance)
            .bind(to: albumCollectionVC.albums)
            .disposed(by: disposeBag)
    }


}

