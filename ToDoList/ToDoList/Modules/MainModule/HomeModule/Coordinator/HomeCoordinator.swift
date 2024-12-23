//
//  HomeCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 21.12.2024.
//

import UIKit
import Combine

final class HomeCoordinator: Coordinator {
    
    //MARK: - Private properties
    
    private let authenticationKey: UUID
    private let authenticationService: AuthService
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, authenticationKey: UUID, authenticationService: AuthService) {
        self.authenticationService = authenticationService
        self.authenticationKey = authenticationKey
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
