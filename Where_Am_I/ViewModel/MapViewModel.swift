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

final class MapViewModel: BaseViewModel {
    
    override init(locationProvider: LocationProviderType) {
        super.init(locationProvider: locationProvider)
        
        locationProvider.currentAddress()
            .bind(to: address)
            .disposed(by: bag)
        
        locationProvider.currentLocation()
            .bind(to: currentLocation)
            .disposed(by: bag)
    }
    
}


