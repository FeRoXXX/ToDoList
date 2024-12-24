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
    
    private var bindings: Set<AnyCancellable> = []
    private var firstOpenService: UserDefaultsService?
    
    init(navigationController: UINavigationController, firstOpenService: UserDefaultsService) {
        self.firstOpenService = firstOpenService
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        print(FileManager.default.temporaryDirectory)
        guard let firstOpenService else { return }
        if firstOpenService.fetchState() {
            goToOnboarding()
        } else {
            if let data = firstOpenService.fetchAuthorizationState() {
                goToHome(authenticationData: data)
                self.firstOpenService = nil
            } else {
                goToAuthentication()
            }
        }
    }
}

extension MainCoordinator {
    
    func goToOnboarding() {
        let coordinator = OnBoardingCoordinator(navigationController: navigationController)
        coordinator.didFinish
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.removeChild(coordinator)
                self?.firstOpenService?.set(isFirstOpen: false)
                self?.start()
            }
            .store(in: &bindings)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func goToAuthentication() {
        let coordinator = AuthenticationCoordinator(navigationController: navigationController)
        coordinator.finishAuthenticationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.firstOpenService?.set(value)
                self?.start()
            }
            .store(in: &bindings)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func goToHome(authenticationData: UUID) {
        let coordinator = HomeTabBarCoordinator(navigationController: navigationController, authenticationData: authenticationData)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
}
