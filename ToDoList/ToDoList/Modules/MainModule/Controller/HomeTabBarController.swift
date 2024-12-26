//
//  HomeTabBarController.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import UIKit

final class HomeTabBarController: UITabBarController {
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

//MARK: - Private extension

private extension HomeTabBarController {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = Colors.clearColor

        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = Colors.lightBlueFirst
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: Colors.lightBlueFirst
        ]

        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = Colors.whiteColorFirst
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: Colors.whiteColorFirst
        ]
        tabBarAppearance.shadowImage = nil
        tabBarAppearance.shadowColor = nil
        self.view.backgroundColor = Colors.clearColor
        self.tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        self.tabBar.isTranslucent = false
    }
}
