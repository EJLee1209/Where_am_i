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
        
        let locationProvider = LocationProvider()
        let searchService = MKSearchService()
        
        let mapViewModel = MapViewModel(title: "Where Am I?",locationProvider: locationProvider, searchService: searchService)
        
        var mapViewController = MapViewController()
        mapViewController.bind(viewModel: mapViewModel)
        let mapNav = UINavigationController(rootViewController: mapViewController)
        
        let starsViewController = StarsViewController()
        let starsNav = UINavigationController(rootViewController: starsViewController)
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([mapNav, starsNav], animated: true)
        
        tabBarController.tabBar.backgroundColor = .white.withAlphaComponent(0.9)
        
        
        if let items = tabBarController.tabBar.items {
            
            items[0].selectedImage = UIImage(systemName: "map.fill")
            items[0].image = UIImage(systemName: "map")
            items[0].title = "Map"
            
            items[1].selectedImage = UIImage(systemName: "star.fill")
            items[1].image = UIImage(systemName: "star")
            items[1].title = "Stars"
            
        }
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

}

