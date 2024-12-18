//
//  SignInCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 19.12.2024.
//

import UIKit

protocol ISignInCoordinator {
    func goToSignUpController()
}

final class SignInCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    var delegate: ISignInCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = SignInViewController()
        navigationController.pushViewController(controller, animated: true)
    }
}
