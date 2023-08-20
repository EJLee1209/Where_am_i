//
//  BaseViewController.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/19.
//

import UIKit

protocol BaseViewController {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
    func configureUI()
}

extension BaseViewController where Self: UIViewController {
    
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
//        loadViewIfNeeded()
        
        
        bindViewModel()
    }
}
