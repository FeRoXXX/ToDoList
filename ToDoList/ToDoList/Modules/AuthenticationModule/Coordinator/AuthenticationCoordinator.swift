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
    private var authenticationMethodSubscriber: AnyCancellable?
    private var routeToBackSubscriber: AnyCancellable?
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, authService: AuthService) {
        self.authService = authService
        super.init(navigationController: navigationController)
    }
    
    //MARK: - override functions
    
    override func start() {
        goToSignInController()
    }
    
    override func finish() {
        authenticationMethodSubscriber = nil
        routeToBackSubscriber = nil
        removeAllChildCoordinators()
    }
}

extension AuthenticationCoordinator {
    
    //MARK: - Go to sign in controller
    
    func goToSignInController(_ animated: Bool = true) {
        let viewModel = SignInViewModel(authService: authService)
        authenticationMethodSubscriber = viewModel.navigateToSignUpPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.goToSignUpController()
            }
        
        routeToBackSubscriber = viewModel.navigateToHomePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.finishAuthenticationPublisher.send(value)
            }
        
        let controller = SignInViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: animated)
    }
    
    //MARK: - Go to sign up controller
    
    func goToSignUpController() {
        let viewModel = SignUpViewModel(authService: authService)
        authenticationMethodSubscriber = viewModel.navigateToSignInPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.goToSignInController(false)
            }
        
        routeToBackSubscriber = viewModel.navigateToHomePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.finishAuthenticationPublisher.send(value)
            }
        
        let controller = SignUpViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: false)
    }
}
