//
//  StarsViewModel.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/20.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources
import Action

final class FavoriteViewModel: BaseViewModel {
    
    override init(title: String, locationProvider: LocationProviderType, searchService: SearchServiceType, placeStorage: PlaceStorageType) {
        super.init(title: title, locationProvider: locationProvider, searchService: searchService, placeStorage: placeStorage)
    }
    
    let favoriteDataSource: RxTableViewSectionedAnimatedDataSource<PlaceSectionModel> = {
        let ds = RxTableViewSectionedAnimatedDataSource<PlaceSectionModel> { dataSource, tableView, indexPath, item in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identity, for: indexPath) as! FavoriteCell
            let cellViewModel = FavoriteCellViewModel(place: item)
            cell.viewModel = cellViewModel
            return cell
        }
        
        ds.canEditRowAtIndexPath = { _, _ in return true }
        
        return ds
    }()
    
    
    //MARK: - Actions
    
    lazy var favoriteDeleteAction: Action<Place, Void> = {
        return Action { [weak self] input in
            guard let self = self else {
                return Observable.empty()
            }
            
            return placeStorage.delete(place: input)
                .map { _ in }
        }
    }()
    
}
