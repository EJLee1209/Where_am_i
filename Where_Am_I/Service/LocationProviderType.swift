//
//  LocationProvider.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/19.
//

import Foundation
import CoreLocation
import RxSwift

protocol LocationProviderType {
    
    // 현재 위치를 방출하는 옵저버블을 리턴
    @discardableResult
    func currentLocation() -> Observable<CLLocation>
    
    // 현재 위치를 통해 현재 주소를 방출하는 옵저버블을 리턴
    @discardableResult
    func currentAddress() -> Observable<String>
    
    // 파라미터로 받은 위치를 통해 주소로 변환하고 방출하는 옵저버블을 리턴
    @discardableResult
    func reverseGeoCodeLocatoin(location: CLLocation) -> Observable<String>
}
