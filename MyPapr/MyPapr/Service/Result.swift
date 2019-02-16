//
//  Result.swift
//  MyPapr
//
//  Created by 突突兔 on 2019/2/16.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import Foundation

public enum Result<T, E> {
    case success(T)
    case error(E)
}
