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
    
    private var authenticationKey: UUID
    private var profileDataService: ProfileDataService
    private var newTaskSubscription: AnyCancellable?
    private var newTaskCancelSubscription: AnyCancellable?
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, authenticationKey: UUID, profileDataService: ProfileDataService) {
        self.authenticationKey = authenticationKey
        self.profileDataService = profileDataService
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        let viewModel = ToDoListViewModel(userId: authenticationKey, profileDataService: profileDataService)
        newTaskSubscription = viewModel.navigateToAddNew
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.routeToAddItem()
            }
        
        let controller = ToDoListViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: true)
    }
    
    override func finish() {
        
    }
}

//MARK: - Private extension

private extension ToDoListCoordinator {
    
    func routeToAddItem() {
        let coordinator = NewTaskCoordinator(navigationController: navigationController, profileDataService: profileDataService, authenticationKey: authenticationKey)
        newTaskCancelSubscription = coordinator.closeNewTaskModule
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.removeChild(coordinator)
                self?.newTaskCancelSubscription = nil
            }
        coordinator.start()
        addChildCoordinator(coordinator)
    }
}
