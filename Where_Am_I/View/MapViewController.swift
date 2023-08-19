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
    
    //MARK: - ViewModel
    var viewModel: MapViewModel!
    func bindViewModel() {
        
        viewModel.currentLocation
            .take(2)
            .bind(to: mapView.rx.setRegionFromLocation)
            .disposed(by: bag)
        
        viewModel.currentLocation
            .bind(to: latLabel.rx.latitude, lonLabel.rx.longitude)
            .disposed(by: bag)
        
        viewModel.address
            .bind(to: addressLabel.rx.text)
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
        
        view.addSubview(bottomBackgroundView)
        bottomBackgroundView.snp.makeConstraints { make in
            make.bottom.right.left.equalTo(view.safeAreaLayoutGuide).inset(18)
            make.height.equalTo(120)
        }
        
        bottomBackgroundView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(18)
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



extension Reactive where Base: UILabel {
    
    var latitude: Binder<CLLocation> {
        return Binder(self.base) { label, location in
            let attributedText = NSMutableAttributedString(string: "Latitude(위도) : ", attributes: [.font: UIFont.systemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "\(location.coordinate.latitude)", attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]))
            label.attributedText = attributedText
        }
    }
    
    var longitude: Binder<CLLocation> {
        return Binder(self.base) { label, location in
            let attributedText = NSMutableAttributedString(string: "Longitude(경도) : ", attributes: [.font: UIFont.systemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "\(location.coordinate.longitude)", attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]))
            label.attributedText = attributedText
        }
    }
    
}
