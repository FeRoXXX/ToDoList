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
    private let profileService: ProfileDataService
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, authenticationKey: UUID, profileService: ProfileDataService) {
        self.profileService = profileService
        self.authenticationKey = authenticationKey
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        let viewModel = HomeViewModel(userId: authenticationKey, profileDataService: profileService)
        let controller = HomeViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: true)
    }
    
    override func finish() {
        
    }
}
