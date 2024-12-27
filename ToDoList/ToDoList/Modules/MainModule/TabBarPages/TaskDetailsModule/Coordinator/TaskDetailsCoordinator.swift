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
    private let profileService: ProfileDataService
    private(set) var routeToBackPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    private var currentWindowSubscription: AnyCancellable?
    private var newTaskCancelSubscription: AnyCancellable?
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, taskId: UUID, profileService: ProfileDataService) {
        self.profileService = profileService
        self.taskId = taskId
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        let viewModel = TaskDetailsViewModel(taskId: taskId, profileDataService: profileService)
        let controller = TaskDetailsViewController(viewModel: viewModel)
        currentWindowSubscription = viewModel.navigation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                switch type {
                case .back:
                    self?.routeToBackPublisher.send()
                    self?.finish()
                case .newTask:
                    self?.routeToCorrectTask()
                }
            }
        navigationController.pushViewController(controller, animated: false)
    }
    
    override func finish() {
        profileService.getUserTasks()
        navigationController.popViewController(animated: false)
    }
}

//MARK: - Private extension

private extension TaskDetailsCoordinator {
    
    func routeToCorrectTask() {
        let coordinator = NewTaskCoordinator(navigationController: navigationController, profileDataService: profileService, taskId: taskId)
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
