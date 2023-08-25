//
//  FavoriteDetailViewController.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/24.
//

import UIKit
import MapKit
import SnapKit
import RxSwift
import RxCocoa

class FavoriteDetailViewController: UIViewController {
    //MARK: - Properties
    
    private let mapView: MKMapView = MKMapView()
    
    var viewModel: DetailViewModel!
    private let bag = DisposeBag()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupNavigationBar()
    }
    
    //MARK: - Helpers
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white.withAlphaComponent(0.5)

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

}

//MARK: - BaseViewController
extension FavoriteDetailViewController: BaseViewController {
    
    
    func bindViewModel() {
        
        viewModel.location
            .bind(to: mapView.rx.setRegionFromLocation)
            .disposed(by: bag)
        
        viewModel.address
            .bind(to: navigationItem.rx.title)
            .disposed(by: bag)
        
        viewModel.annotationInfo
            .map { $0 }
            .bind(to: mapView.rx.annotation)
            .disposed(by: bag)
            
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
