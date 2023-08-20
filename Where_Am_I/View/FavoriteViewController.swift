//
//  StarsViewController.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/20.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoriteViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identity)
        tv.rowHeight = 120
        return tv
    }()
    
    private let bag = DisposeBag()
    var viewModel: FavoriteViewModel!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
}

extension FavoriteViewController: BaseViewController {
    
    func bindViewModel() {
        navigationItem.title = viewModel.title
        
        viewModel.favoriteList
            .bind(to: tableView.rx.items(dataSource: viewModel.favoriteDataSource))
            .disposed(by: bag)
        
        tableView.rx.modelDeleted(Place.self)
            .bind(to: viewModel.favoriteDeleteAction.inputs)
            .disposed(by: bag)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}


