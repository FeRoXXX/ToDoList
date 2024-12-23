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
    
    func setupUI() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = Colors.clearColor

        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        ]

        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.white
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white
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
