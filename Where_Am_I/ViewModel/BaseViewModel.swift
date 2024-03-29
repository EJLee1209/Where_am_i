//
//  BaseViewModel.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/19.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay
import RxCocoa

class BaseViewModel: NSObject {
    
    let title: String
    let bag = DisposeBag()
    let address = BehaviorRelay<String>(value: "")
    let currentLocation = BehaviorRelay<CLLocation>(value: CLLocation.gangnamStation)
    
    let locationProvider: LocationProviderType
    let searchService: SearchServiceType
    let placeStorage: PlaceStorageType
    
    var favoriteList: Observable<[PlaceSectionModel]> {
        return placeStorage.read()
    }
    
    init(title: String, locationProvider: LocationProviderType, searchService: SearchServiceType, placeStorage: PlaceStorageType) {
        self.title = title
        self.locationProvider = locationProvider
        self.searchService = searchService
        self.placeStorage = placeStorage
        
    }
    
    
}
