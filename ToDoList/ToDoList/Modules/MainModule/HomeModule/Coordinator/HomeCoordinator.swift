//
//  HomeCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 21.12.2024.
//

import UIKit
import Combine

final class HomeCoordinator: Coordinator {
    
    //MARK: - Initialization
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        let controller = HomeViewController()
        navigationController.setViewControllers([controller], animated: true)
    }
    
    override func finish() {
        
    }
}
