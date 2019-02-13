//
//  EeathquakeListViewController.swift
//  RxEarthquakeLearning
//
//  Created by 突突兔 on 2019/1/28.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class EarthquakeListViewController: UITableViewController {
    
    private var viewModelFactory: (EarthquakeListViewModel.UIInputs) -> EarthquakeListViewModel = { _ in fatalError("must provide factory function first.") }
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearsSelectionOnViewWillAppear = false
        let refreshControl = self.refreshControl!
        let inputs = EarthquakeListViewModel.UIInputs(
            selectEarthquake: tableView.rx.itemSelected.asObservable(),
            refreshTrigger: refreshControl.rx.controlEvent(.valueChanged).asObservable(),
            viewAppearTrigger: rx.methodInvoked(#selector(viewDidAppear(_:))).map { _ in }
        )
        viewModelFactory = { input -> EarthquakeListViewModel in
            let vm = EarthquakeListViewModel(inputs, dataTask: dataTask)
            return vm
        }
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        let viewModel = viewModelFactory(inputs)
        let cellViewModels = viewModel.earthquakeCellViewModels
        
        cellViewModels
            .drive(tableView.rx.items(cellIdentifier: "EarthquakeTableViewCell", cellType: EarthquakeTableViewCell.self)) {
                (index, viewModel, cell) in
                cell.configure(viewModel: viewModel)
            }
            .disposed(by: disposeBag)
        
        viewModel.endRefreshing
            .drive(onNext: {
                refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }

    

}
