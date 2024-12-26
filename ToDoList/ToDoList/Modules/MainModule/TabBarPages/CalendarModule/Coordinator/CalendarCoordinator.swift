//
//  CalendarCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 25.12.2024.
//

import UIKit
import Combine

final class CalendarCoordinator: Coordinator {
    
    //MARK: - Private properties
    
    private(set) var routeToBackSubscription: AnyCancellable?
    private(set) var routeToDetailsSubscription: AnyCancellable?
    private var profileDataService: ProfileDataService
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, profileDataService: ProfileDataService) {
        self.profileDataService = profileDataService
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        let viewModel = CalendarViewModel(profileDataService: profileDataService)
        let controller = CalendarViewController(viewModel: viewModel)
        routeToDetailsSubscription = viewModel.routeToDetails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.routeToTaskDetails(taskId: value)
            }
        navigationController.setViewControllers([controller], animated: true)
    }
    
    override func finish() {
    }
}

//MARK: - Private extension

private extension CalendarCoordinator {
    
    //MARK: - Route to task detail
    
    func routeToTaskDetails(taskId: UUID) {
        navigationController.isNavigationBarHidden = true
        let coordinator = TaskDetailsCoordinator(navigationController: navigationController, taskId: taskId, profileService: profileDataService)
        coordinator.start()
        routeToBackSubscription = coordinator.routeToBackPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.removeChild(coordinator)
                self?.routeToBackSubscription = nil
            }
        addChildCoordinator(coordinator)
    }
}
