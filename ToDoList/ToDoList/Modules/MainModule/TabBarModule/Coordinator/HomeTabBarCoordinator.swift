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
    private var authenticationData: UUID
    private(set) var routeToAuthenticationPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, authenticationData: UUID) {
        self.authenticationData = authenticationData
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
        navigationController.view.layer.insertSublayer(Background.shared.getGradientLayer(frame: navigationController.view.frame), at: 0)
        switch page {
        case .home:
            let coordinator = HomeCoordinator(navigationController: navigationController, authenticationKey: authenticationData, profileService: ProfileDataService.shared)
            addChildCoordinator(coordinator)
            coordinator.start()
            return coordinator.navigationController
        case .toDoList:
            let coordinator = ToDoListCoordinator(navigationController: navigationController, authenticationKey: authenticationData, profileDataService: ProfileDataService.shared)
            addChildCoordinator(coordinator)
            coordinator.start()
            return coordinator.navigationController
        case .calendar:
            let coordinator = HomeCoordinator(navigationController: navigationController, authenticationKey: authenticationData, profileService: ProfileDataService.shared)
            addChildCoordinator(coordinator)
            coordinator.start()
            return coordinator.navigationController
        case .settings:
            let coordinator = SettingsCoordinator(navigationController: navigationController, authenticationKey: authenticationData, profileDataService: ProfileDataService.shared)
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
