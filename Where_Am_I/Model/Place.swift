//
//  Place.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/20.
//

import Foundation
import RxDataSources

typealias PlaceSectionModel = AnimatableSectionModel<Int, Place>

struct Place: Equatable, IdentifiableType {
    var name: String
    let latitude: Double
    let longitude: Double
    var insertDate: Date
    var identity: String
    
    
    init(name: String, latitude: Double, longitude: Double, insertDate: Date = Date()) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    init(original: Place, newName: String) {
        self = original
        self.name = newName
    }
}
