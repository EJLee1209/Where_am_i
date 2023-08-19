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

class BaseViewModel: NSObject {
    
    let bag = DisposeBag()
    let address = BehaviorRelay<String>(value: "")
    let currentLocation = BehaviorRelay<CLLocation>(value: CLLocation.gangnamStation)
    
    let locationProvider: LocationProviderType
    
    init(locationProvider: LocationProviderType) {
        self.locationProvider = locationProvider
    }
}
