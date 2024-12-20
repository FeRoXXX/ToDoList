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
    
    init(navigationController: UINavigationController, firstOpenService: FirstOpenService) {
        self.firstOpenService = firstOpenService
        super.init(navigationController: navigationController)
    }
    
    override func start() {
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
                self?.removeChild(coordinator)
                self?.firstOpenService.set(isFirstOpen: false)
                self?.start()
                self?.bindings.removeAll()
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
