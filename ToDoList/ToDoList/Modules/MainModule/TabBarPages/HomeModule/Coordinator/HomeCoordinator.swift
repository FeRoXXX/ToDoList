//
//  HomeCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 21.12.2024.
//

import UIKit
import Combine

final class HomeCoordinator: Coordinator {
    
    //MARK: - Private properties
    
    private let profileService: ProfileDataService
    private var routeToBackSubscription: AnyCancellable?
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, profileService: ProfileDataService) {
        self.profileService = profileService
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        let viewModel = HomeViewModel(profileDataService: profileService)
        let controller = HomeViewController(viewModel: viewModel)
        viewModel.navigateToTaskDetails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] taskId in
                self?.navigateToTaskDetails(with: taskId)
            }
            .store(in: &bindings)
        navigationController.setViewControllers([controller], animated: true)
    }
    
    override func finish() {
        removeAllChildCoordinators()
        bindings.removeAll()
        routeToBackSubscription = nil
    }
}

//MARK: - Private extension

private extension HomeCoordinator {
    
    //MARK: - Navigate to task details
    
    func navigateToTaskDetails(with id: UUID) {
        navigationController.isNavigationBarHidden = true
        let coordinator = TaskDetailsCoordinator(navigationController: navigationController, taskId: id, profileService: profileService)
        routeToBackSubscription = coordinator.routeToBackPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.removeChild(coordinator)
                self?.routeToBackSubscription = nil
            }
        coordinator.start()
        addChildCoordinator(coordinator)
    }
}
