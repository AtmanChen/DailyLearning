//
//  UseCaseProvider.swift
//  Domain
//
//  Created by 突突兔 on 2019/2/15.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import Foundation

public protocol UseCaseProvider {
    func makePostUseCase() -> PostUseCase
}
