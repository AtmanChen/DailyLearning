//
//  BindableType.swift
//  MyPapr
//
//  Created by 突突兔 on 2019/2/16.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit

protocol BindableType {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}


extension BindableType where Self: UIViewController {
    mutating func bind(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}


extension BindableType where Self: UICollectionViewCell {
    mutating func bind(to model: Self.ViewModelType) {
        viewModel = model
        bindViewModel()
    }
}
