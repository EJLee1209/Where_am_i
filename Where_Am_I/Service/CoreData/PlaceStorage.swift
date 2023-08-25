//
//  PlaceStorage.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/25.
//

import Foundation
import RxSwift
import RxRelay
import CoreData
import RxCoreData

final class PlaceStorage: PlaceStorageType {

    let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    //MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }


    func create(name: String, lat: Double, lon: Double) -> Observable<Place> {
        let place = Place(name: name, latitude: lat, longitude: lon)
        
        do {
            _ = try mainContext.rx.update(place)
            return Observable.just(place)
        } catch {
            return Observable.error(error)
        }
    }

    func read() -> Observable<[PlaceSectionModel]> {
        return mainContext.rx.entities(Place.self, sortDescriptors: [NSSortDescriptor(key: "insertDate", ascending: false)])
            .map { result in [PlaceSectionModel(model: 0, items: result)] }
    }

    func update(place: Place, newName: String) -> Observable<Place> {
        let updated = Place(original: place, newName: newName)
        
        do {
            _ = try mainContext.rx.update(updated)
            
            return Observable.just(updated)
        } catch {
            return Observable.error(error)
        }
    }

    func delete(place: Place) -> Observable<Place> {
        do {
            try mainContext.rx.delete(place)
            
            return Observable.just(place)
        } catch {
            return Observable.error(error)
        }
    }


}
