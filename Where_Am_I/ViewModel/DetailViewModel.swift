//
//  DetailViewModel.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/25.
//

import Foundation
import RxSwift
import CoreLocation

final class DetailViewModel {
    
    let place: Place
    
    init(place: Place) {
        self.place = place
    }
    
    var location: Observable<CLLocation> {
        return Observable.just(CLLocation(latitude: place.latitude, longitude: place.longitude))
    }
    
    var address: Observable<String> {
        return Observable.just(place.name)
    }
    
    var annotationInfo: Observable<(CLLocationCoordinate2D, String)> {
        return Observable.zip(location, address)
            .map { ($0.0.coordinate, $0.1) }
    }
}
