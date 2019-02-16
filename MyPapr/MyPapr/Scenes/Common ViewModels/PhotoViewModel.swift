//
//  PhotoViewModel.swift
//  MyPapr
//
//  Created by 突突兔 on 2019/2/16.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import Foundation
import RxSwift
import Action
import Photos


protocol PhotoViewModelInput {
//    var likePhotoAction: Action<Photo, Photo> { get }
//    var unlikePhotoAction: Action<Photo, Photo> { get }
//    var downloadPhotoAction: Action<Photo, String> { get }
//    var writeImageToPhotoAlbumAction: Action<UIImage, Void> { get }
}

protocol PhotoViewModelOutput {
    var photoStream: Observable<Photo>! { get }
    var regularPhoto: Observable<String>! { get }
    var photoSize: Observable<(Double, Double)>! { get }
    var totalLikes: Observable<String>! { get }
    var likedByUser: Observable<Bool>! { get }
}


protocol PhotoViewModelType {
    var photoViewModelInputs: PhotoViewModelInput { get }
    var photoViewModelOuputs: PhotoViewModelOutput { get }
}

class PhotoViewModel: PhotoViewModelType, PhotoViewModelInput, PhotoViewModelOutput {
    
    
    // MARK: Inputs & Outputs
    var photoViewModelInputs: PhotoViewModelInput { return self }
    var photoViewModelOuputs: PhotoViewModelOutput { return self }
    
    // MARK: Input
    
    
    // MARK: Output
    var regularPhoto: Observable<String>!
    var photoSize: Observable<(Double, Double)>!
    var totalLikes: Observable<String>!
    var likedByUser: Observable<Bool>!
    var photoStream: Observable<Photo>!
    
    let cache: Cache
    let service: PhotoServiceType
    let sceneCoordinator: SceneCoordinatorType
    
    // MARK: Init
    init(photo: Photo,
        cache: Cache = Cache.shared,
        service: PhotoServiceType = PhotoService(),
        sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared
         ) {
        self.cache = cache
        self.service = service
        self.sceneCoordinator = sceneCoordinator
        
        photoStream = Observable.just(photo)
        
        regularPhoto = photoStream
            .map { $0.urls?.regular }
            .unwrap()
        
        photoSize = Observable.combineLatest(
            photoStream.map { $0.width }.unwrap().map { Double($0) },
            photoStream.map { $0.height }.unwrap().map { Double($0) }
        )
        
        let cachedPhoto = cache.getObject(ofType: Photo.self, withId: photo.id ?? "").unwrap()
        
        self.totalLikes = .just("10000")
        self.likedByUser = .just(true)
    }
}
