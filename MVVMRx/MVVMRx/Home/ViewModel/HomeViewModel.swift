//
//  HomeViewModel.swift
//  MVVMRx
//
//  Created by 突突兔 on 2019/2/13.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import RxCocoa
import RxSwift

private let requestUrl = "dcd86ebedb5e519fd7b09b79dd4e4558/raw/b7505a54339f965413f5d9feb05b67fb7d0e464e/MvvmExampleApi.json"

class HomeViewModel {
    
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    let albums: PublishSubject<[Album]> = PublishSubject()
    let tracks: PublishSubject<[Track]> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    func requestData() {
        APIManager
            .requestData(url: requestUrl,
                      method: .get,
                  parameters: nil) { result in
                    switch result {
                    case let .success(json):
                        let albums = json["Albums"].arrayValue.compactMap { Album(data: try! $0.rawData()) }
                        let tracks = json["Tracks"].arrayValue.compactMap { Track(data: try! $0.rawData()) }
                        self.albums.onNext(albums)
                        self.tracks.onNext(tracks)
                    case let .failure(failure):
                        switch failure {
                        case .connectionError:
                            self.error.onNext(.internetError("Check your Internet connection."))
                        default:
                            self.error.onNext(.serverMessage("Unknown Error"))
                        }
                    }
        }
    }
    
}
