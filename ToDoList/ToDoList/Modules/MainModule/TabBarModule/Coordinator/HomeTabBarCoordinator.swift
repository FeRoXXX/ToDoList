//
//  HomeTabBarCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 21.12.2024.
//

import UIKit
import Combine

final class HomeTabBarCoordinator: Coordinator {
    
    //MARK: - Private properties
    
    private var tabBarController: UITabBarController = UITabBarController()
    
    //MARK: - Initialization
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override methods
    
    override func start() {
        let pages: [TabBarPages] = [.home, .toDoList, .calendar, .settings]
        navigationController.setViewControllers([tabBarController], animated: true)
        let controllers: [UINavigationController] = pages.map {prepareViewController(page: $0)}
        prepareTabBarController(with: controllers)
    }
    
    override func finish() {
        
    }
    
    func prepareTabBarController(with controllers: [UINavigationController]) {
        tabBarController.setViewControllers(controllers, animated: true)
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .clear

        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        ]

        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.white
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        tabBarController.tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        tabBarController.selectedIndex = TabBarPages.home.pageNumber()
        tabBarController.tabBar.isTranslucent = false
        navigationController.viewControllers = [tabBarController]
    }
    
    func prepareViewController(page: TabBarPages) -> UINavigationController {
        let navigationController = UINavigationController()
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.tabBarItem = UITabBarItem(title: nil,
                                                       image: page.pageImageView(),
                                                       tag: page.pageNumber())
        navigationController.view.layer.insertSublayer(Background.shared.getGradientLayer(frame: navigationController.view.frame), at: 0)
        switch page {
        case .home:
            let coordinator = HomeCoordinator(navigationController: navigationController)
            addChildCoordinator(coordinator)
            coordinator.start()
            return coordinator.navigationController
        case .toDoList:
            let coordinator = ToDoListCoordinator(navigationController: navigationController)
            addChildCoordinator(coordinator)
            coordinator.start()
            return coordinator.navigationController
        case .calendar:
            let coordinator = HomeCoordinator(navigationController: navigationController)
            addChildCoordinator(coordinator)
            coordinator.start()
            return coordinator.navigationController
        case .settings:
            let coordinator = SettingsCoordinator(navigationController: navigationController)
            addChildCoordinator(coordinator)
            coordinator.start()
            return coordinator.navigationController
        }
    }
}
