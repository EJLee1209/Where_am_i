//
//  SearchServiceType.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/19.
//

import Foundation
import MapKit
import RxSwift
import RxRelay

protocol SearchServiceType {
    
    var keyword: BehaviorRelay<String> { get }
    
    func search(for suggestedCompletion: MKLocalSearchCompletion) -> Observable<CLLocation?>
    
    func fetchResult() -> Observable<[SearchSectionModel]>
}
