//
//  MKLocalSearchCompletion+.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/19.
//

import Foundation
import MapKit
import RxSwift
import RxDataSources

extension MKLocalSearchCompletion: ObservableConvertibleType {
    public func asObservable() -> RxSwift.Observable<MKLocalSearchCompletion> {
        return Observable.just(self)
    }
    
    public typealias Element = MKLocalSearchCompletion
}

extension MKLocalSearchCompletion: IdentifiableType {
    
    public var identity: String {
        return "\(self.title) \(self.subtitle)"
    }
    
}
