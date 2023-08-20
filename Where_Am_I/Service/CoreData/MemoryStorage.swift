//
//  MemoryStorage.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/20.
//

import Foundation
import RxSwift

class MemoryStorage: PlaceStorageType {
    
    private var list = [
        Place(name: "강북구", latitude: 37.6268728, longitude: 127.026923),
        Place(name: "서초동", latitude: 37.4831672, longitude: 127.031757)
    ]
    
    private lazy var sectionModel = PlaceSectionModel(model: 0, items: list)
    
    private lazy var store = BehaviorSubject<[PlaceSectionModel]>(value: [sectionModel])
    
    
    //MARK: - CRUD
    
    func create(name: String, lat: Double, lon: Double) -> RxSwift.Observable<Place> {
        let place = Place(name: name, latitude: lat, longitude: lon)
        sectionModel.items.insert(place, at: 0)
        
        store.onNext([sectionModel])
        
        return Observable.just(place)
    }
    
    func read() -> RxSwift.Observable<[PlaceSectionModel]> {
        return store
    }
    
    func update(place: Place, newName: String) -> RxSwift.Observable<Place> {
        let updatedPlace = Place(original: place, newName: newName)
        
        if let index = sectionModel.items.firstIndex(where: { $0 == place }) {
            
            sectionModel.items.remove(at: index)
            sectionModel.items.insert(updatedPlace, at: index)
            
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(updatedPlace)
        
    }
    
    func delete(place: Place) -> RxSwift.Observable<Place> {
        if let index = sectionModel.items.firstIndex(where: { $0 == place }) {
            sectionModel.items.remove(at: index)
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(place)
    }
    
    
    
    
}
