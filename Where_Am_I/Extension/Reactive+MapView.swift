//
//  Reactive+MapView.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/19.
//

import Foundation
import MapKit
import CoreLocation
import RxSwift

extension Reactive where Base: MKMapView {
    
    var setRegionFromLocation: Binder<CLLocation> {
        return Binder(self.base) { mapView, location in
            let region = MKCoordinateRegion(center: location.coordinate, span: .init(latitudeDelta: 1, longitudeDelta: 1))
            mapView.setRegion(region, animated: true)
        }
    }
    
}
