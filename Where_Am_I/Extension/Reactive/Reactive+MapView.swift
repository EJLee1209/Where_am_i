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
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    var annotation: Binder<(coord: CLLocationCoordinate2D, address: String)> {
        return Binder(self.base) { (mapView, location) in
            let annotation = CustomAnnotation(title: location.address, subtitle: "", coordinate: location.coord)
            
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(annotation)
        }
    }
    
    
    
}


