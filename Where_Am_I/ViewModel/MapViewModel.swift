//
//  MapViewModel.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/19.
//

import RxSwift
import RxRelay
import Foundation
import CoreLocation
import RxDataSources
import UIKit
import MapKit
import Action

final class MapViewModel: BaseViewModel {
    
    let searchText: BehaviorSubject<String> = .init(value: "")
    
    let searchResult: BehaviorRelay<[SearchSectionModel]> = .init(value: [])
    
    let selectedItem: PublishSubject<MKLocalSearchCompletion> = .init()
    let selectedLocation: PublishRelay<CLLocation> = .init()
    let selectedAddress: PublishRelay<String> = .init()
    
    let pinIsActive: BehaviorRelay<Bool> = .init(value: false)
    let regionIsChanging: BehaviorRelay<Bool> = .init(value: false)
    let pinOffSet: BehaviorRelay<Int> = .init(value: 0)
    
    override init(title: String, locationProvider: LocationProviderType, searchService: SearchServiceType) {
        super.init(title: title, locationProvider: locationProvider, searchService: searchService)
        
        locationProvider.currentAddress()
            .bind(to: address)
            .disposed(by: bag)
        
        locationProvider.currentLocation()
            .bind(to: currentLocation)
            .disposed(by: bag)
        
        searchText
            .bind(to: searchService.keyword)
            .disposed(by: bag)
        
        searchService.fetchResult()
            .bind(to: searchResult)
            .disposed(by: bag)
        
        selectedItem
            .withUnretained(self)
            .flatMap { viewModel,item in
                viewModel.searchService.search(for: item)
            }
            .compactMap { $0 }
            .bind(to: selectedLocation)
            .disposed(by: bag)
        
        selectedLocation
            .withUnretained(self)
            .flatMap { viewModel, location in
                viewModel.locationProvider.reverseGeoCodeLocatoin(location: location)
            }
            .bind(to: selectedAddress)
            .disposed(by: bag)
        
        regionIsChanging
            .map { value -> Int in
                value ? -5 : 15
            }
            .bind(to: pinOffSet)
            .disposed(by: bag)
    
    }
    
    let searchResultDataSource: RxTableViewSectionedAnimatedDataSource<SearchSectionModel> = {
        
        let ds = RxTableViewSectionedAnimatedDataSource<SearchSectionModel> { dataSource, tableView, indexPath, data -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
            cell.textLabel?.text = data.title
            return cell
            
        }
        
        return ds
    }()
    
    //MARK: - Actions
    
    func makePinButtonAction() -> CocoaAction {
        return CocoaAction { [weak self] _ in
            guard let self = self else {
                return Observable.empty()
            }
            
            pinIsActive.accept(!pinIsActive.value)
            
            return Observable.empty()
        }
    }
}


