//
//  MKSearchService.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/19.
//

import Foundation
import MapKit
import RxSwift
import RxRelay
import RxDataSources

typealias SearchSectionModel = AnimatableSectionModel<Int, MKLocalSearchCompletion>

class MKSearchService: SearchServiceType {
    
    let keyword = BehaviorRelay(value: "") // 검색어

    let searchCompleter = MKLocalSearchCompleter()
    
    let searchResults = BehaviorRelay<[SearchSectionModel]>(value: [])
    
    private let bag = DisposeBag()
    
    init() {
        
        searchCompleter.resultTypes = .address
        
        keyword.throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: searchCompleter.rx.queryFragment)
            .disposed(by: bag)
        
        searchCompleter.rx.didUpdateResults
            .map { [SearchSectionModel(model: 0, items: $0)] }
            .bind(to: searchResults)
            .disposed(by: bag)
        
    }
    
    func search(for suggestedCompletion: MKLocalSearchCompletion) {
        
    }
    
    func search(using searchRequest: MKLocalSearch.Request) -> RxSwift.Observable<CLLocation> {
        return Observable.empty()
    }
    
    func fetchResult() -> Observable<[SearchSectionModel]> {
        return searchResults.asObservable()
    }
}

