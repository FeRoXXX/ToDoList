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
    
    private var tabBarController: HomeTabBarController = HomeTabBarController()
    private var profileDataService: ProfileDataService
    private(set) var routeToAuthenticationPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, profileDataService: ProfileDataService) {
        self.profileDataService = profileDataService
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override methods
    
    override func start() {
        navigationController.isNavigationBarHidden = true
        let pages: [TabBarPages] = [.home, .toDoList, .calendar, .settings]
        navigationController.setViewControllers([tabBarController], animated: true)
        let controllers: [UINavigationController] = pages.map {prepareViewController(page: $0)}
        prepareTabBarController(with: controllers)
    }
    
    override func finish() {
        removeAllChildCoordinators()
        tabBarController.removeFromParent()
        bindings.removeAll()
    }
    
    //MARK: - Prepare tab bar controller
    
    func prepareTabBarController(with controllers: [UINavigationController]) {
        tabBarController.setViewControllers(controllers, animated: true)
        tabBarController.selectedIndex = TabBarPages.home.pageNumber()
        navigationController.viewControllers = [tabBarController]
    }
    
    //MARK: - Prepare view controllers
    func prepareViewController(page: TabBarPages) -> UINavigationController {
        let navigationController = UINavigationController()
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.tabBarItem = UITabBarItem(title: nil,
                                                       image: page.pageImageView(),
                                                       tag: page.pageNumber())
        navigationController.view.layer.insertSublayer(navigationController.view.frame.getGradientLayer(colorTop: Colors.Background.appBackgroundTop,
                                                                                                        colorBottom: Colors.Background.appBackgroundBottom,
                                                                                                        startPoint: CGPoint(x: 0, y: 0),
                                                                                                        endPoint: CGPoint(x: 0, y: 1)),
                                                       at: 0)
        switch page {
        case .home:
            let coordinator = HomeCoordinator(navigationController: navigationController, profileService: profileDataService)
            addChildCoordinator(coordinator)
            coordinator.start()
            return coordinator.navigationController
        case .toDoList:
            let coordinator = ToDoListCoordinator(navigationController: navigationController, profileDataService: profileDataService)
            addChildCoordinator(coordinator)
            coordinator.start()
            return coordinator.navigationController
        case .calendar:
            let coordinator = CalendarCoordinator(navigationController: navigationController, profileDataService: profileDataService)
            addChildCoordinator(coordinator)
            coordinator.start()
            return coordinator.navigationController
        case .settings:
            let coordinator = SettingsCoordinator(navigationController: navigationController, profileDataService: profileDataService)
            addChildCoordinator(coordinator)
            coordinator.start()
            coordinator.coordinatorFinishPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    coordinator.finish()
                    self?.routeToAuthenticationPublisher.send()
                }
                .store(in: &bindings)
            return coordinator.navigationController
        }
    }
}
