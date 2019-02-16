//
//  HomeViewCellModelType.swift
//  MyPapr
//
//  Created by 突突兔 on 2019/2/16.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import Foundation
import RxSwift
import Action



protocol HomeViewCellModelInput: PhotoViewModelInput {
    
}


protocol HomeViewCellModelOutput: PhotoViewModelOutput {
    var userProfileImage: Observable<String>! { get }
    var fullname: Observable<String>! { get }
    var username: Observable<String>! { get }
    var smallPhoto: Observable<String>! { get }
    var fullPhoto: Observable<String>! { get }
    var updated: Observable<String>! { get }
}


protocol HomeViewCellModelType: PhotoViewModelType {
    var inputs: HomeViewCellModelInput { get }
    var outputs: HomeViewCellModelOutput { get }
}

class HomeViewCellModel: PhotoViewModel, HomeViewCellModelType, HomeViewCellModelInput, HomeViewCellModelOutput {
    
    
    // MARK: Inputs & Outputs
    var inputs: HomeViewCellModelInput { return self }
    override var photoViewModelInputs: PhotoViewModelInput { return inputs }
    
    var outputs: HomeViewCellModelOutput { return self }
    override var photoViewModelOuputs: PhotoViewModelOutput { return outputs }
    
    // MARK: Outputs
    var userProfileImage: Observable<String>!
    var fullname: Observable<String>!
    var username: Observable<String>!
    var smallPhoto: Observable<String>!
    var fullPhoto: Observable<String>!
    var updated: Observable<String>!
    
    // MARK: Private
    
    
    
    // MARK: Init
    override init(
        photo: Photo,
        cache: Cache = Cache.shared,
        service: PhotoServiceType = PhotoService(),
        sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        super.init(photo: photo)
        
        userProfileImage = photoStream
            .map { $0.user?.profileImage?.medium }
            .unwrap()
        
        fullname = photoStream
            .map { $0.user?.fullName }
            .unwrap()
        
        username = photoStream
            .map { "@\($0.user?.username ?? "")" }
        
        smallPhoto = photoStream
            .map { $0.urls?.small }
            .unwrap()
        
        fullPhoto = photoStream
            .map { $0.urls?.full }
            .unwrap()
        
        updated = .just("good")
    }
}
