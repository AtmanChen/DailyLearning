//
//  EarthquakeListViewModel.swift
//  RxEarthquakeLearning
//
//  Created by 突突兔 on 2019/1/28.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import Foundation
import RxSwiftExt
import RxSwift
import RxCocoa


struct EarthquakeListViewModel {
    struct UIInputs {
        let selectEarthquake: Observable<IndexPath>
        let refreshTrigger: Observable<Void>
        let viewAppearTrigger: Observable<Void>
    }
    
    // UI Output
    let earthquakeCellViewModels: Driver<[EarthquakeCellViewModel]>
    let endRefreshing: Driver<Void>
    let errorMessage: Driver<String>
    
    // coordinator outputs
//    let displayEarthquake: Driver<Earthquake>
}


extension EarthquakeListViewModel {
    init(_ inputs: UIInputs, dataTask: @escaping DataTask) {
        let networkResonse = Observable.merge(inputs.refreshTrigger, inputs.viewAppearTrigger)
            .map { URLRequest.earthquakeSummary }
            .flatMapLatest { dataTask($0) }
            .share()
        
        let earthquakeServerResponse = networkResonse
            .map { $0.successResponse }
            .unwrap()
        
        let error = networkResonse
            .map { $0.failureResponse }
            .unwrap()
            .map { $0.localizedDescription }
        
        let failure = earthquakeServerResponse
            .filter { $0.1.statusCode != 200 }
            .map { "There was a server error: \($0)" }
        
        let earthquakes = earthquakeServerResponse
            .filter { $0.1.statusCode / 100 == 2 }
            .map { Earthquake.earthquakes(from: $0.0) }
        
        earthquakeCellViewModels = earthquakes
            .map { $0.map { EarthquakeCellViewModel($0) } }
            .asDriverLogError()
        
        endRefreshing = networkResonse
            .map { _ in }
            .throttle(0.5, scheduler: MainScheduler.instance)
            .asDriverLogError()
        
        errorMessage = Observable.merge(error, failure)
            .asDriverLogError()
        
    }
}


typealias DataTask = (URLRequest) -> Single<URLResponse>
