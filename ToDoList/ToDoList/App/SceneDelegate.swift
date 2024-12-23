//
//  SceneDelegate.swift
//  ToDoList
//
//  Created by Александр Федоткин on 16.12.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController.init()
        mainCoordinator = MainCoordinator(navigationController: navigationController, firstOpenService: UserDefaultsService())
        mainCoordinator?.start()
        window.makeKeyAndVisible()
        window.rootViewController = navigationController
        self.window = window
    }
}

