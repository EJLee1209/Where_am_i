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
        
        let startVC = MapViewController()
        var nav = UINavigationController(rootViewController: startVC)
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

}

