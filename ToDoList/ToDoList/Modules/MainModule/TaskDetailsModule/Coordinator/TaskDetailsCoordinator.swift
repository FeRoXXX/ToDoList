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
    private var routeToBackSubscribe: AnyCancellable?
    
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
        routeToBackSubscribe = viewModel.routeToBack
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.finish()
            }
        navigationController.pushViewController(controller, animated: true)
    }
    
    override func finish() {
        routeToBackPublisher.send()
    }
}
