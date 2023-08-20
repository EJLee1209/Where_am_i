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
    private lazy var searchController = UISearchController(searchResultsController: SearchViewController(viewModel: viewModel))
    private let bag = DisposeBag()
    
    private let bottomBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(white: 1.0, alpha: 0.7)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let latLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let lonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [addressLabel, latLabel, lonLabel])
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private let userTrackingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "scope"), for: .normal)
        button.backgroundColor = .init(white: 1.0, alpha: 0.7)
        button.tintColor = .black
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    
    //MARK: - ViewModel
    var viewModel: MapViewModel!
    func bindViewModel() {
        
        viewModel.currentLocation
            .take(2)
            .bind(to: mapView.rx.setRegionFromLocation, latLabel.rx.latitude, lonLabel.rx.longitude)
            .disposed(by: bag)
        
        viewModel.address
            .take(2)
            .bind(to: addressLabel.rx.text, rx.title)
            .disposed(by: bag)
        
        userTrackingButton.rx.tap
            .map { self.viewModel.currentLocation.value }
            .bind(to: mapView.rx.setRegionFromLocation, latLabel.rx.latitude, lonLabel.rx.longitude)
            .disposed(by: bag)
        
        userTrackingButton.rx.tap
            .map { self.viewModel.address.value }
            .bind(to: addressLabel.rx.text, rx.title)
            .disposed(by: bag)
        
        searchController.searchBar.rx.text
            .compactMap { $0 }
            .bind(to: viewModel.searchText)
            .disposed(by: bag)
        
        viewModel.selectedLocation
            .bind(to: mapView.rx.setRegionFromLocation, latLabel.rx.latitude, lonLabel.rx.longitude)
            .disposed(by: bag)
        
        viewModel.selectedAddress
            .bind(to: addressLabel.rx.text, rx.title)
            .disposed(by: bag)
        
        Observable.zip(viewModel.selectedLocation, viewModel.selectedAddress)
            .map { ($0.0.coordinate,$0.1) }
            .bind(to: mapView.rx.annotation)
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
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bottomBackgroundView)
        bottomBackgroundView.snp.makeConstraints { make in
            make.bottom.right.left.equalTo(view.safeAreaLayoutGuide).inset(22)
            make.height.equalTo(120)
        }
        
        bottomBackgroundView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(18)
        }
        
        view.addSubview(userTrackingButton)
        userTrackingButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.bottom.equalTo(bottomBackgroundView.snp.top).offset(-12)
            make.right.equalTo(bottomBackgroundView)
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



