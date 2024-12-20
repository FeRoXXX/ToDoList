//
//  AuthenticationCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 19.12.2024.
//

import UIKit
import Combine

final class AuthenticationCoordinator: Coordinator {
    
    private var bindings: Set<AnyCancellable> = []
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToSignInController()
    }
}

extension AuthenticationCoordinator {
    
    func goToSignInController(_ animated: Bool = true) {
        let viewModel = SignInViewModel()
        viewModel.navigateToSignUpPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.goToSignUpController()
            }
            .store(in: &bindings)
        let controller = SignInViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: animated)
    }
    
    func goToSignUpController() {
        let viewModel = SignUpViewModel()
        viewModel.navigateToSignInPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.goToSignInController(false)
            }
            .store(in: &bindings)
        
        let controller = SignUpViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: false)
    }
}
