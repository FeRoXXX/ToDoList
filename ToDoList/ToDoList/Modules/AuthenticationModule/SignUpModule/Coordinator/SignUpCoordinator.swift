//
//  SignUpCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 19.12.2024.
//

import UIKit

protocol ISignUpCoordinator {
    func goToSignInController()
}

final class SignUpCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    var delegate: ISignUpCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = SignUpViewController()
        navigationController.setViewControllers([controller], animated: true)
    }
}
