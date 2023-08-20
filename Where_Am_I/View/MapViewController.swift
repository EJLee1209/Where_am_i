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
import Action

final class MapViewController : UIViewController {
    
    //MARK: - Properties
    private let mapView = MKMapView()
    private lazy var searchController = UISearchController(searchResultsController: SearchViewController(viewModel: viewModel))
    
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
    
    private lazy var locationInfoStack: UIStackView = {
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
    
    private var pinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        button.backgroundColor = .init(white: 1.0, alpha: 0.7)
        button.tintColor = .black
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    
    private var pinImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "icon_pin")
        return iv
    }()
    
    private var addFavoriteButton = UIBarButtonItem(systemItem: .add)
    
    
    var viewModel: MapViewModel!
    
    private let bag = DisposeBag()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupMapView()
        setupNavigationBar()
    }
    
    //MARK: - Helpers
    
    private func setupMapView() {
        mapView.showsUserLocation = true
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white.withAlphaComponent(0.5)

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.setRightBarButton(addFavoriteButton, animated: true)
    }
}

//MARK: - BaseViewController
extension MapViewController: BaseViewController {
    
    func bindViewModel() {
        
        navigationItem.title = viewModel.title
        
        viewModel.currentLocation
            .compactMap { $0 }
            .take(2)
            .bind(to: mapView.rx.setRegionFromLocation, latLabel.rx.latitude, lonLabel.rx.longitude)
            .disposed(by: bag)
        
        viewModel.address
            .take(2)
            .bind(to: addressLabel.rx.text, navigationItem.rx.title)
            .disposed(by: bag)
        
        userTrackingButton.rx.tap
            .map { self.viewModel.currentLocation.value }
            .bind(to: mapView.rx.setRegionFromLocation, latLabel.rx.latitude, lonLabel.rx.longitude)
            .disposed(by: bag)
        
        userTrackingButton.rx.tap
            .map {
                self.viewModel.selectedLocation.accept(nil)
                return self.viewModel.address.value
            }
            .bind(to: addressLabel.rx.text, navigationItem.rx.title)
            .disposed(by: bag)
        
        searchController.searchBar.rx.text
            .compactMap { $0 }
            .bind(to: viewModel.searchText)
            .disposed(by: bag)
        
        viewModel.selectedLocation
            .compactMap { $0 }
            .bind(to: mapView.rx.setRegionFromLocation, latLabel.rx.latitude, lonLabel.rx.longitude)
            .disposed(by: bag)
        
        viewModel.selectedAddress
            .bind(to: addressLabel.rx.text, navigationItem.rx.title)
            .disposed(by: bag)
        
        Observable.zip(viewModel.selectedLocation.compactMap { $0 }, viewModel.selectedAddress)
            .filter({ _ in
                return !self.viewModel.pinIsActive.value
            })
            .map { ($0.0.coordinate,$0.1) }
            .bind(to: mapView.rx.annotation)
            .disposed(by: bag)
        
        pinButton.rx.action = viewModel.makePinButtonAction()
        
        viewModel.pinIsActive
            .bind(to: pinButton.rx.tintColor, pinImageView.rx.isHidden)
            .disposed(by: bag)
        
        mapView.rx.regionIsChanging
            .skip(2)
            .bind(to: viewModel.regionIsChanging)
            .disposed(by: bag)
        
        mapView.rx.regionDidChanged
            .skip(2)
            .filter({ _ in
                self.viewModel.pinIsActive.value
            })
            .map { _ in
                let coord = self.mapView.centerCoordinate
                return CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            }
            .bind(to: viewModel.selectedLocation)
            .disposed(by: bag)
        
        viewModel.pinOffSet
            .skip(1)
            .subscribe(onNext: { offset in
                self.remakeConstraints(offset: offset)
            })
            .disposed(by: bag)
        
        addFavoriteButton.rx.action = viewModel.makeAddFavoriteButtonAction(parentViewController: self)
    }
    
    func remakeConstraints(offset: Int) {
        if !viewModel.pinIsActive.value { return }
        
        pinImageView.snp.updateConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(mapView).offset(offset)
            make.size.equalTo(45)
        }

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.pinImageView.superview?.layoutIfNeeded()
        }
    }
    
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
        
        bottomBackgroundView.addSubview(locationInfoStack)
        locationInfoStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(18)
        }
        
        view.addSubview(userTrackingButton)
        userTrackingButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.bottom.equalTo(bottomBackgroundView.snp.top).offset(-12)
            make.right.equalTo(bottomBackgroundView)
        }
        
        view.addSubview(pinButton)
        pinButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.bottom.equalTo(userTrackingButton.snp.top).offset(-12)
            make.right.equalTo(bottomBackgroundView)
        }
        
        view.addSubview(pinImageView)
        pinImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(mapView).offset(15)
            make.size.equalTo(45)
        }
        
        
        
    }
    
    
}


