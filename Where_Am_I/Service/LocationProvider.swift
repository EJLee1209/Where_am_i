//
//  LocationProvider.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/19.
//

import Foundation
import RxSwift
import RxRelay
import CoreLocation

class LocationProvider: LocationProviderType {
    
    private let locationManager = CLLocationManager()
    
    private let location = BehaviorRelay<CLLocation>(value: CLLocation.gangnamStation)
    
    private let address = BehaviorRelay<String>(value: "강남역")
    
    private let authorized = BehaviorRelay<Bool>(value: false)
    
    private let bag = DisposeBag()
    
    init() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = true
        
        locationManager.rx.didUpdateLocation
            .compactMap { $0.first }
            .bind(to: location)
            .disposed(by: bag)
        
        location.flatMap { [weak self] location in
            self?.reverseGeoCodeLocatoin(location: location) ?? Observable.just("알 수 없음")
        }
        .bind(to: address)
        .disposed(by: bag)
    }
    
    func currentLocation() -> Observable<CLLocation> {
        return location.asObservable()
    }
    
    func currentAddress() -> Observable<String> {
        return address.asObservable()
    }
    
    func reverseGeoCodeLocatoin(location: CLLocation) -> Observable<String> {
        return Observable<String>.create { observer in
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let place = placemarks?.first {
                    
                    if let gu = place.locality, let dong = place.subLocality {
                        observer.onNext("\(gu) \(dong)")
                    } else {
                        observer.onNext(place.name ?? "알 수 없음")
                    }
                    
                } else {
                    observer.onNext("알 수 없음")
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    
}
