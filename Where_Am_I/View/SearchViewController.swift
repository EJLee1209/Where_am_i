//
//  SearchViewController.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/19.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

final class SearchViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 50
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "SearchCell")
        return tv
    }()
    
    private let bag = DisposeBag()
    
    //MARK: - ViewModel
    let viewModel: MapViewModel
    
    func bindViewModel() {
        
        viewModel.searchResult
            .asDriver()
            .drive(tableView.rx.items(dataSource: viewModel.searchResultDataSource))
            .disposed(by: bag)
        
        tableView.rx.modelSelected(MKLocalSearchCompletion.self)
            .flatMap { $0 }
            .bind(to: viewModel.selectedItem)
            .disposed(by: bag)
        
    }
    
    //MARK: - LifeCycle
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
}

