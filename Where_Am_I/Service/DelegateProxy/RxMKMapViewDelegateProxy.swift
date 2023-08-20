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
    
    enum RegionChangeState {
        case start
        case end
    }
    
    var regionWillChange: Observable<RegionChangeState> {
        let sel = #selector(MKMapViewDelegate.mapView(_:regionWillChangeAnimated:))
        
        return delegate.methodInvoked(sel)
            .map { _ in .start }
            .asObservable()
    }
    
    var regionDidChanged: Observable<RegionChangeState> {
        let sel = #selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:))
        
        return delegate.methodInvoked(sel)
            .map { _ in .end }
            .asObservable()
    }
    
    
    var regionIsChanging: Observable<Bool> {        
        return Observable.merge(regionDidChanged, regionWillChange)
            .map { $0 == .start }
            .asObservable()
    }
    
}



