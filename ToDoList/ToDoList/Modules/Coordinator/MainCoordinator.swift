//
//  MainCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 18.12.2024.
//

import UIKit
import Combine

final class MainCoordinator: Coordinator {
    
    //MARK: - Private properties
    
    private var firstOpenService: UserDefaultsService?
    private var binding: AnyCancellable?
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, firstOpenService: UserDefaultsService) {
        self.firstOpenService = firstOpenService
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        print(FileManager.default.temporaryDirectory)
        guard let firstOpenService else { return }
        if firstOpenService.fetchState() {
            goToOnboarding()
        } else {
            if let data = firstOpenService.fetchAuthorizationState() {
                goToHome(authenticationData: data)
            } else {
                goToAuthentication()
            }
        }
    }
}

extension MainCoordinator {
    
    //MARK: - Go to onbording
    
    func goToOnboarding() {
        let coordinator = OnBoardingCoordinator(navigationController: navigationController)
        binding = coordinator.didFinish
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.firstOpenService?.set(isFirstOpen: false)
                coordinator.finish()
                self?.start()
                self?.removeChild(coordinator)
            }
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    //MARK: - Go to Authentication
    
    func goToAuthentication() {
        let coordinator = AuthenticationCoordinator(navigationController: navigationController, authService: AuthService())
        binding = coordinator.finishAuthenticationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                coordinator.finish()
                self?.firstOpenService?.set(value)
                self?.start()
                self?.removeChild(coordinator)
            }
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    //MARK: - Go to home
    
    func goToHome(authenticationData: UUID) {
        let coordinator = HomeTabBarCoordinator(navigationController: navigationController, authenticationData: authenticationData)
        addChildCoordinator(coordinator)
        binding = coordinator.routeToAuthenticationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                coordinator.finish()
                self?.start()
                self?.removeChild(coordinator)
            }
        
        coordinator.start()
    }
}
