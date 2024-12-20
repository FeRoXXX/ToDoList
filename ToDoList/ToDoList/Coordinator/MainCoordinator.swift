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
    private var firstOpenService: FirstOpenService
    
    //MARK: - Public properties
    
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, firstOpenService: FirstOpenService) {
        self.navigationController = navigationController
        self.firstOpenService = firstOpenService
    }
    
    func start() {
        if firstOpenService.fetchState() {
            goToOnboarding()
        } else {
            goToAuthentication()
        }
    }
}

extension MainCoordinator {
    
    func goToOnboarding() {
        let coordinator = OnBoardingCoordinator(navigationController: navigationController)
        coordinator.didFinish
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.didFinish(coordinator)
                self?.firstOpenService.set(isFirstOpen: false)
                self?.start()
            }
            .store(in: &bindings)
        children.append(coordinator)
        coordinator.start()
    }
    
    func goToAuthentication() {
        let coordinator = AuthenticationCoordinator(navigationController: navigationController)
        children.append(coordinator)
        coordinator.start()
    }
}
