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
    
    private var userDefaultsService: UserDefaultsService
    private var binding: AnyCancellable?
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, userDefaultsService: UserDefaultsService) {
        self.userDefaultsService = userDefaultsService
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        print(FileManager.default.temporaryDirectory)
        if userDefaultsService.fetchState() {
            goToOnboarding()
        } else {
            if let data = userDefaultsService.fetchAuthorizationState() {
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
                self?.userDefaultsService.set(isFirstOpen: false)
                coordinator.finish()
                self?.start()
                self?.removeChild(coordinator)
            }
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    //MARK: - Go to Authentication
    
    func goToAuthentication() {
        let coreDataService = CoreDataService()
        let coordinator = AuthenticationCoordinator(navigationController: navigationController,
                                                    authService: AuthService(coreDataService: coreDataService))
        binding = coordinator.finishAuthenticationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                coordinator.finish()
                self?.userDefaultsService.set(value)
                self?.start()
                self?.removeChild(coordinator)
            }
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    //MARK: - Go to home
    
    func goToHome(authenticationData: UUID) {
        let coreDataService = CoreDataService()
        let profileDataService = ProfileDataService(authenticationKey: authenticationData,
                                                    userDefaultService: userDefaultsService,
                                                    coreDataService: coreDataService)
        let coordinator = HomeTabBarCoordinator(navigationController: navigationController, profileDataService: profileDataService)
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
