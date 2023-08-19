//
//  MapViewController.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/19.
//

import UIKit
import MapKit
import SnapKit
import RxSwift
import RxCocoa

final class MapViewController : UIViewController, BaseViewController {
    
    //MARK: - Properties
    private let mapView = MKMapView()
    private let searchController = UISearchController(searchResultsController: SearchViewController())
    private let bag = DisposeBag()
    
    //MARK: - ViewModel
    var viewModel: MapViewModel!
    func bindViewModel() {
        
        viewModel.currentLocation
            .bind(to: mapView.rx.setRegionFromLocation)
            .disposed(by: bag)
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupMapView()
        setupNavigationBar()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupMapView() {
        mapView.showsUserLocation = true
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Where Am I?"
        navigationItem.searchController = searchController
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white.withAlphaComponent(0.5)

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}



