//
//  SceneDelegate.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/19.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        var startVC = MapViewController()
        
        let locationProvider = LocationProvider()
        let searchService = MKSearchService()
        
        let mapViewModel = MapViewModel(locationProvider: locationProvider, searchService: searchService)
        
        startVC.bind(viewModel: mapViewModel)
        let nav = UINavigationController(rootViewController: startVC)
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

}

