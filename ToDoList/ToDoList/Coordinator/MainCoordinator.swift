//
//  MainCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 18.12.2024.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToAuthentication()
    }
}

extension MainCoordinator {
    
    func goToAuthentication() {
        let coordinator = AuthenticationCoordinator(navigationController: navigationController)
        children.append(coordinator)
        coordinator.start()
    }
}
