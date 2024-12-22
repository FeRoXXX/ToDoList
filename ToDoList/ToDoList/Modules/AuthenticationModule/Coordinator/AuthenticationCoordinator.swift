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
    private(set) var finishAuthenticationPublisher: PassthroughSubject<Void, Never> = .init()
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
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
        
        viewModel.navigateToHomePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.finishAuthenticationPublisher.send()
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
        
        viewModel.navigateToHomePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.finishAuthenticationPublisher.send()
            }
            .store(in: &bindings)
        
        let controller = SignUpViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: false)
    }
}
