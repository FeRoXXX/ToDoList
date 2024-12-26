//
//  TaskDetailsCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 24.12.2024.
//

import UIKit
import Combine

final class TaskDetailsCoordinator: Coordinator {
    
    //MARK: - Private properties
    
    private let taskId: UUID
    private var authenticationKey: UUID
    private let profileService: ProfileDataService
    private(set) var routeToBackPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    private var routeToCorrectSubscribe: AnyCancellable?
    private var routeToBackSubscribe: AnyCancellable?
    private var newTaskCancelSubscription: AnyCancellable?
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, taskId: UUID, profileService: ProfileDataService, authenticationKey: UUID) {
        self.profileService = profileService
        self.taskId = taskId
        self.authenticationKey = authenticationKey
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        let viewModel = TaskDetailsViewModel(taskId: taskId, profileDataService: profileService)
        let controller = TaskDetailsViewController(viewModel: viewModel)
        routeToBackSubscribe = viewModel.routeToBack
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.routeToBackPublisher.send()
                self?.finish()
            }
        
        routeToCorrectSubscribe = viewModel.routeToNewTask
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.routeToCorrectTask()
            })
        navigationController.pushViewController(controller, animated: false)
    }
    
    override func finish() {
//        profileService.getUserIncompleteTasks(userId: authenticationKey)
        profileService.getUserTasksByUserId(authenticationKey)
        navigationController.popViewController(animated: false)
    }
}

//MARK: - Private extension

private extension TaskDetailsCoordinator {
    
    func routeToCorrectTask() {
        let coordinator = NewTaskCoordinator(navigationController: navigationController, profileDataService: profileService, authenticationKey: authenticationKey, taskId: taskId)
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
