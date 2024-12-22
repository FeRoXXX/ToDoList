//
//  ToDoListCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit
import Combine

final class ToDoListCoordinator: Coordinator {
    
    //MARK: - Initialization
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        let controller = ToDoListViewController()
        navigationController.setViewControllers([controller], animated: true)
    }
    
    override func finish() {
        
    }
}
