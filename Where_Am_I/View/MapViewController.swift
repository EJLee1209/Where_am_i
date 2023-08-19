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
    
    var viewModel: MapViewModel!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Helpers
    func bindViewModel() {
        
        viewModel.currentLocation
            .map {
                MKCoordinateRegion(center: $0.coordinate, span: .init(latitudeDelta: 1, longitudeDelta: 1))
            }
            .bind(to: mapView.rx.region)
            .disposed(by: bag)
        
        mapView.showsUserLocation = true
            
        
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Where Am I?"
        navigationItem.searchController = searchController
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white.withAlphaComponent(0.5)

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}



