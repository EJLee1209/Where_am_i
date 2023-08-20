//
//  RxMKMapKitDelegateProxy.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/20.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

extension MKMapView: HasDelegate {
    public typealias Delegate = MKMapViewDelegate
}

public class RxMKMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, DelegateProxyType, MKMapViewDelegate {
    
    public init(mapView: MKMapView) {
        super.init(parentObject: mapView, delegateProxy: RxMKMapViewDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxMKMapViewDelegateProxy(mapView:  $0) }
    }
    
}

extension Reactive where Base: MKMapView {
    
    var delegate: DelegateProxy<MKMapView, MKMapViewDelegate> {
        return RxMKMapViewDelegateProxy.proxy(for: base)
    }
    
    var regionDidChanged: Observable<Void> {
        let sel = #selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:))
        
        return delegate.methodInvoked(sel)
            .map { _ in }
            .asObservable()
    }
    
    var regionWillChange: Observable<Void> {
        let sel = #selector(MKMapViewDelegate.mapView(_:regionWillChangeAnimated:))
        
        return delegate.methodInvoked(sel)
            .map { _ in }
            .asObservable()
    }
    
}

