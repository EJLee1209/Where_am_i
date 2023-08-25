//
//  Place.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/20.
//

import Foundation
import RxDataSources
import CoreData
import RxCoreData

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

extension Place: Persistable {
    static var entityName: String {
        return "Place"
    }
    
    static var primaryAttributeName: String {
        return "identity" // pk 속성 이름
    }
    
    init(entity: NSManagedObject) {
        name = entity.value(forKey: "name") as! String
        latitude = entity.value(forKey: "latitude") as! Double
        longitude = entity.value(forKey: "longitude") as! Double
        insertDate = entity.value(forKey: "insertDate") as! Date
        identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(name, forKey: "name")
        entity.setValue(latitude, forKey: "latitude")
        entity.setValue(longitude, forKey: "longitude")
        entity.setValue(insertDate, forKey: "insertDate")
        entity.setValue("\(insertDate.timeIntervalSinceReferenceDate)", forKey: "identity")
        
        do {
            try entity.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
}
