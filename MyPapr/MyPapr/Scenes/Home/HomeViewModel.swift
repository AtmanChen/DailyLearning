//
//  HomeViewModel.swift
//  MyPapr
//
//  Created by 突突兔 on 2019/2/16.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import Foundation
import RxSwift
import Action


protocol HomeViewModelInput {
    
    var showPhotosAction: Action<PhotosType, Void> { get }
    func refresh()
}

protocol HomeViewModelOutput {
    var photos: Observable<[Photo]>! { get }
    var isRefreshing: Observable<Bool>! { get }
    var photosType: Observable<PhotosType>! { get }
    var orderBy: Observable<OrderBy>! { get }
    var homeViewCellModelTypes: Observable<[HomeViewCellModelType]> { get }
}


protocol HomeViewModelType {
    var inputs: HomeViewModelInput { get }
    var outputs: HomeViewModelOutput { get }
}


class HomeViewModel: HomeViewModelType,
                     HomeViewModelInput,
                     HomeViewModelOutput {
    
    
    // MARK: Inputs & Outputs
    var inputs: HomeViewModelInput { return self }
    var outputs: HomeViewModelOutput { return self }
    
    func refresh() {
        refreshProperty.onNext(true)
    }
    
    lazy var showPhotosAction: Action<PhotosType, Void> = {
        Action<PhotosType, Void> { [unowned self] type in
            self.photosTypeProperty.onNext(type)
            self.refresh()
            return .empty()
        }
    }()
    
    lazy var orderByAction: Action<OrderBy, Void> = {
        Action<OrderBy, Void> { [unowned self] orderBy in
            orderBy == .latest ?
                self.orderByProperty.onNext(.popular) :
                self.orderByProperty.onNext(.latest)
            self.refresh()
            return .empty()
        }
    }()
    
    // MARK: Output
    var photos: Observable<[Photo]>!
    var isRefreshing: Observable<Bool>!
    var photosType: Observable<PhotosType>!
    var orderBy: Observable<OrderBy>!
    
    // MARK: Private
    private let cache: Cache
    private let service: PhotoServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private let refreshProperty = BehaviorSubject<Bool>(value: true)
    private let orderByProperty = BehaviorSubject<OrderBy>(value: .latest)
    private let photosTypeProperty = BehaviorSubject<PhotosType>(value: .newest)
    
    lazy var homeViewCellModelTypes: Observable<[HomeViewCellModelType]> = {
        return Observable.combineLatest(photos, cache.getAllObjects(ofType: Photo.self))
            .map { photos, cachedPhotos -> [Photo] in
                var photoArray: [Photo] = []
                for (photo, cachedPhoto) in zip(photos, cachedPhotos) {
                    var copyPhoto = photo
                    copyPhoto.likes = cachedPhoto.likes
                    copyPhoto.likedByUser = cachedPhoto.likedByUser
                    photoArray.append(copyPhoto)
                }
                return photoArray
            }
            .mapMany { HomeViewCellModel(photo: $0) }
    }()
    
    init(cache: Cache = Cache.shared,
         service: PhotoServiceType = PhotoService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.cache = cache
        self.service = service
        self.sceneCoordinator = sceneCoordinator
        
        var currentPageNumber = 1
        var photoArray: [Photo] = []
        
        isRefreshing = refreshProperty.asObservable()
        photosType = photosTypeProperty.asObservable()
        orderBy = orderByProperty.asObservable()
        
        let requestFirst = Observable
            .combineLatest(isRefreshing, orderBy, photosType.map { $0 == .curated })
            .flatMapLatest { isRefreshing, orderBy, isCurated -> Observable<[Photo]> in
                guard isRefreshing else {
                    return .empty()
                }
                return service.photos(by: 1, orderBy: orderBy, curated: isCurated)
                    .flatMap { [unowned self] result -> Observable<[Photo]> in
                        switch result {
                        case let .success(ps):
                            return .just(ps)
                        case .error:
                            self.refreshProperty.onNext(false)
                            return .empty()
                        }
                    }
            }
            .do(onNext: { _ in
                photoArray = []
                currentPageNumber = 1
            })
        
        photos = requestFirst
            .map { [unowned self] photos -> [Photo] in
                photos.forEach { photo in
                    photoArray.append(photo)
                }
                self.refreshProperty.onNext(false)
                return photoArray
            }
    }
}
