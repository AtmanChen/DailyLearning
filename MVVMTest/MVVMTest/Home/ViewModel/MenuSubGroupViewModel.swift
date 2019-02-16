//
//  MenuSubGroupViewModel.swift
//  MVVMTest
//
//  Created by 突突兔 on 2019/2/15.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift



class MenuSubGroupViewModel {
    
    
    
    func transform(input: Input) -> Output {
        let loadingTracker = ActivityIndicator()
        
        let renameGroup = input.cellRenameButtonTap
            .flatMapLatest { _ in
                return Driver.just(())
            }
        
        let getMenusInfo = Driver.merge(input.viewDidLoad, renameGroup)
            .flatMapLatest { _ in
                self.getMenusInfo()
                    .trackActivity(loadingTracker)
                    .asDriver(onErrorJustReturn: [])
            }
        let loading = loadingTracker.asDriver()
        return Output(dataSource: getMenusInfo, loading: loading)
    }
    
    
    private func getMenusInfo() -> Single<[CellSectionModel]> {
        return RxOpenAPIProvider.rx.request(.newList)
            .mapToArray(type: GroupModel.self)
            .asSingle()
            .map { result in
                return [CellSectionModel(items: result)]
            }
        
    }
    
}

extension MenuSubGroupViewModel {
    
    struct Input {
        let viewDidLoad: Driver<Void>
        let cellDeleteButtonTap: Driver<IndexPath>
        let cellRenameButtonTap: Driver<IndexPath>
    }
    
    struct Output {
        let dataSource: Driver<[CellSectionModel]>
        let loading: Driver<Bool>
    }
}
