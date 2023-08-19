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
    
    func search(for suggestedCompletion: MKLocalSearchCompletion) -> Observable<CLLocation?> {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        
        searchRequest.region = MKCoordinateRegion(.world)
        searchRequest.resultTypes = .address
        let localSearch = MKLocalSearch(request: searchRequest)
        
        return Observable.create { observer in
            
            localSearch.start { response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let coord = response?.mapItems[0].placemark.coordinate else {
                    observer.onNext(nil)
                    return
                }
                
                let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                
                observer.onNext(location)
                
                observer.onCompleted()
            }
            
            return Disposables.create()
        }.catchAndReturn(nil)
    }
    
    func fetchResult() -> Observable<[SearchSectionModel]> {
        return searchResults.asObservable()
    }
}

