//
//  ToDoListCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit
import Combine

final class ToDoListCoordinator: Coordinator {
    
    //MARK: - Private properties
    
    private var profileDataService: ProfileDataService
    private var newTaskCancelSubscription: AnyCancellable?
    private var navigationSubscriber: AnyCancellable?
    private var routeToBackSubscription: AnyCancellable?
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, profileDataService: ProfileDataService) {
        self.profileDataService = profileDataService
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        let viewModel = ToDoListViewModel(profileDataService: profileDataService)
        
        navigationSubscriber = viewModel.navigationPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] type in
                switch type {
                case .toAddNew:
                    self?.routeToAddItem()
                case .toDetails(let id):
                    self?.routeToTaskDetails(taskId: id)
                }
            })
        let controller = ToDoListViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: true)
    }
    
    override func finish() {
        newTaskCancelSubscription = nil
        navigationSubscriber = nil
        routeToBackSubscription = nil
    }
}

//MARK: - Private extension

private extension ToDoListCoordinator {
    
    func routeToAddItem() {
        let coordinator = NewTaskCoordinator(navigationController: navigationController, profileDataService: profileDataService)
        newTaskCancelSubscription = coordinator.closeNewTaskModule
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                coordinator.finish()
                self?.removeChild(coordinator)
                self?.newTaskCancelSubscription = nil
            }
        coordinator.start()
        addChildCoordinator(coordinator)
    }
    
    func routeToTaskDetails(taskId: UUID) {
        navigationController.isNavigationBarHidden = true
        let coordinator = TaskDetailsCoordinator(navigationController: navigationController, taskId: taskId, profileService: profileDataService)
        coordinator.start()
        routeToBackSubscription = coordinator.routeToBackPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                coordinator.finish()
                self?.removeChild(coordinator)
                self?.routeToBackSubscription = nil
            }
        addChildCoordinator(coordinator)
    }
}
