//
//  HomeViewCell.swift
//  MyPapr
//
//  Created by 突突兔 on 2019/2/16.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit
import RxSwift
import Nuke
import RxNuke
import Photos
import Hero

class HomeViewCell: UICollectionViewCell, BindableType, NibIdentifiable & ClassIdentifiable {
    typealias ViewModelType = HomeViewCellModelType
    var viewModel: HomeViewCellModelType!
    
    
    
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postedTimeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var downloadPhotoButton: UIButton!
    @IBOutlet weak var collectPhotoButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: private
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()
    private let dummyImageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.roundCorners(withRadius: Constants.Appearance.Style.imageCornerRadius)
        photoButton.isExclusiveTouch = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.image = nil
        photoImageView.image = nil
        dummyImageView.image = nil
        likeButton.rx.action = nil
        photoButton.rx.action = nil
        disposeBag = DisposeBag()
    }
    
    func bindViewModel() {
//        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        
        let this = HomeViewCell.self
        
        outputs.photoStream
            .map { $0.id }
            .unwrap()
            .bind(to: photoImageView.rx.heroId)
            .disposed(by: disposeBag)
        
        outputs.userProfileImage
            .mapToURL()
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .map { $0.image }
            .bind(to: avatarImageView.rx.image)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            outputs.smallPhoto,
            outputs.regularPhoto,
            outputs.fullPhoto)
            .flatMap { small, regular, full -> Observable<ImageResponse> in
                return Observable.concat(
                    this.imagePipeline.rx.loadImage(with: URL(string: small)!).asObservable(),
                    this.imagePipeline.rx.loadImage(with: URL(string: regular)!).asObservable(),
                    this.imagePipeline.rx.loadImage(with: URL(string: full)!).asObservable()
                )
            }
            .map { $0.image }
            .flatMapIgnore { [unowned self] _ in
                Observable.just(self.activityIndicator.stopAnimating())
            }
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)
        
        outputs.fullname
            .bind(to: fullNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.username
            .bind(to: usernameLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.totalLikes
            .bind(to: likesCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.updated
            .bind(to: postedTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.likedByUser
            .map { $0 ? UIImage(named: "favorite-black") : UIImage(named: "favorite-border-black") }
            .bind(to: likeButton.rx.image())
            .disposed(by: disposeBag)
        
        
    }
    
}
