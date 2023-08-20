//
//  FavoriteCellViewModel.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/20.
//

import Foundation
import RxSwift
import RxRelay

final class FavoriteCellViewModel {
    
    let place: Place
    
    var name: String {
        return place.name
    }
    
    var latitude: String {
        return "Latitude(위도) : \(place.latitude)"
    }
    
    var longitude: String {
        return "Longitude(경도) : \(place.longitude)"
    }
    
    init(place: Place) {
        self.place = place
    }
    
}
