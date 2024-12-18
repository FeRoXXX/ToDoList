//
//  AuthenticationCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 19.12.2024.
//

import UIKit

final class AuthenticationCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToSignInController()
    }
}

extension AuthenticationCoordinator: ISignUpCoordinator, ISignInCoordinator {
    
    func goToSignInController() {
        let coordinator = SignInCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        children.append(coordinator)
        coordinator.start()
    }
    
    func goToSignUpController() {
        let coordinator = SignUpCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        children.append(coordinator)
        coordinator.start()
    }
}
