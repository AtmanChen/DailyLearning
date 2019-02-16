//
//  PhotoService.swift
//  MyPapr
//
//  Created by 突突兔 on 2019/2/16.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking


final class PhotoService: PhotoServiceType {
    
    private let unsplash: TinyNetworking<Unsplash>
    private let cache: Cache
    
    init(unsplash: TinyNetworking<Unsplash> = TinyNetworking<Unsplash>(),
         cache: Cache = Cache.shared) {
        self.unsplash = unsplash
        self.cache = cache
    }
    
    
    
    
    
    
    
    func photos(by pageNumber: Int = 1,
                orderBy: OrderBy = .latest,
                curated: Bool = false) -> Observable<Result<[Photo], String>> {
        if pageNumber == 1 {
            cache.clear()
        }
        
        let photos: Unsplash = curated ?
            .curatedPhotos(page: pageNumber, perPage: Constants.photosPerPage, orderBy: orderBy) :
            .photos(page: pageNumber, perPage: Constants.photosPerPage, orderBy: orderBy)
        
        return unsplash.rx.request(resource: photos)
            .map(to: [Photo].self)
            .asObservable()
            .flatMapIgnore { Observable.just(self.cache.set(values: $0)) }
            .map(Result.success)
            .catchError { Observable.just(.error($0.localizedDescription)) }
    }
    
    
}
