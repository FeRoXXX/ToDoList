//
//  AuthenticationCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 19.12.2024.
//

import UIKit
import Combine

final class AuthenticationCoordinator: Coordinator {
    
    //MARK: - Private properties
    
    private(set) var finishAuthenticationPublisher: PassthroughSubject<UUID, Never> = .init()
    private var authService: AuthService?
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, authService: AuthService) {
        self.authService = authService
        super.init(navigationController: navigationController)
    }
    
    //MARK: - override functions
    
    override func start() {
        goToSignInController()
    }
}

extension AuthenticationCoordinator {
    
    //MARK: - Go to sign in controller
    
    func goToSignInController(_ animated: Bool = true) {
        let viewModel = SignInViewModel(authService: authService)
        viewModel.navigateToSignUpPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.goToSignUpController()
            }
            .store(in: &bindings)
        
        viewModel.navigateToHomePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.finishAuthenticationPublisher.send(value)
            }
            .store(in: &bindings)
        let controller = SignInViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: animated)
    }
    
    //MARK: - Go to sign up controller
    
    func goToSignUpController() {
        let viewModel = SignUpViewModel(authService: authService)
        viewModel.navigateToSignInPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.goToSignInController(false)
            }
            .store(in: &bindings)
        
        viewModel.navigateToHomePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.finishAuthenticationPublisher.send(value)
            }
            .store(in: &bindings)
        
        let controller = SignUpViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: false)
    }
}
