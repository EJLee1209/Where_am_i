//
//  PlaceStorageType.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/20.
//

import Foundation
import RxSwift

protocol PlaceStorageType {
    @discardableResult
    func create(name: String, lat: Double, lon: Double) -> Observable<Place>
    
    @discardableResult
    func read() -> Observable<[PlaceSectionModel]>
    
    @discardableResult
    func update(place: Place, newName: String) -> Observable<Place>
    
    @discardableResult
    func delete(place: Place) -> Observable<Place>
}
