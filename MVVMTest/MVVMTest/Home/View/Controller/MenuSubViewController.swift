//
//  MenuSubViewController.swift
//  MVVMTest
//
//  Created by 突突兔 on 2019/2/15.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MenuSubViewController: UIViewController {
    
    private let cellDeleteButtonTap = PublishSubject<IndexPath>()
    private let cellRenameButtonTap = PublishSubject<IndexPath>()
    private let viewModel = MenuSubGroupViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.register(LabelButtonCell.self, forCellReuseIdentifier: "LabelButtonCell")
        return tableView
    }()
    
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<CellSectionModel> = {
        return RxTableViewSectionedReloadDataSource<CellSectionModel>(configureCell: { (_, tableView, indexPath, model) -> UITableViewCell in
            let cell: LabelButtonCell = tableView.dequeueReusableCell(withIdentifier: "LabelButtonCell", for: indexPath) as! LabelButtonCell
            cell.data = (model.name ?? "", "", "重命名", "删除")
            cell.rightButton1.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    self?.cellDeleteButtonTap.onNext(indexPath)
                })
                .disposed(by: cell.disposeBag)
            
            cell.rightButton2.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    self?.cellRenameButtonTap.onNext(indexPath)
                })
                .disposed(by: cell.disposeBag)
            return cell
        })
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "分组管理"
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        let viewDidLoad = Driver.just(())
        let input = MenuSubGroupViewModel.Input(viewDidLoad: viewDidLoad, cellDeleteButtonTap: cellDeleteButtonTap.asDriverOnErrorJustComplete(), cellRenameButtonTap: cellRenameButtonTap.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        output
            .loading
            .drive(rx.isLoading)
            .disposed(by: disposeBag)
        output
            .dataSource
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    

}

extension MenuSubViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

struct CellSectionModel {
    var items: [Item]
}

extension CellSectionModel: SectionModelType {
    typealias Item = GroupModel
    init(original: CellSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}




