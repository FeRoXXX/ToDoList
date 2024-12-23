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
    
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        let viewModel = ToDoListViewModel()
        viewModel.navigateToAddItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.routeToAddItem()
            }
            .store(in: &bindings)
        
        let controller = ToDoListViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: true)
    }
    
    override func finish() {
        
    }
    
    func routeToAddItem() {
        let coordinator = NewNoteCoordinator(navigationController: navigationController)
        coordinator.start()
        addChildCoordinator(coordinator)
    }
}
