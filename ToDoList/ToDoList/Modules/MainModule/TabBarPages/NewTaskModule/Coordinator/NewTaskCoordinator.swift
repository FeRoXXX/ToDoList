//
//  NewTaskCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import UIKit
import Combine

final class NewTaskCoordinator: Coordinator {
    
    //MARK: - Private properties
    
    private var profileDataService: ProfileDataService
    private var taskId: UUID?
    private(set) var closeNewTaskModule: PassthroughSubject<Void, Never> = .init()
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, profileDataService: ProfileDataService, taskId: UUID? = nil) {
        self.profileDataService = profileDataService
        self.taskId = taskId
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        let viewModel = NewTaskViewModel(profileDataService: profileDataService, taskId: taskId)
        let controller = NewTaskViewController(viewModel: viewModel)
        viewModel.cancelNewTaskModule
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.finish()
                self?.closeNewTaskModule.send()
            }
            .store(in: &bindings)
        controller.modalTransitionStyle = .coverVertical
        controller.modalPresentationStyle = .overFullScreen
        navigationController.present(controller, animated: true)
    }
    
    override func finish() {
        navigationController.dismiss(animated: true)
        self.bindings.removeAll()
    }
}
