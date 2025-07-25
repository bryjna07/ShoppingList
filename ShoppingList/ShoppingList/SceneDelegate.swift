//
//  SceneDelegate.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let naviVC = UINavigationController(rootViewController: MainViewController())
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
            .foregroundColor: UIColor.white,
        ]

        naviVC.navigationBar.tintColor = .white
        naviVC.navigationBar.standardAppearance = appearance
        naviVC.navigationBar.compactAppearance = appearance
        naviVC.navigationBar.scrollEdgeAppearance = appearance
        
        window?.rootViewController = naviVC
        window?.makeKeyAndVisible()
    }
}

