//
//  SettingsCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit
import Combine

final class SettingsCoordinator: Coordinator {
    
    //MARK: - Private properties
    
    private var profileDataService: ProfileDataService
    private(set) var coordinatorFinishPublisher: PassthroughSubject<Void, Never> = .init()
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(navigationController: UINavigationController, profileDataService: ProfileDataService) {
        self.profileDataService = profileDataService
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        let viewModel = SettingsViewModel(profileDataService: profileDataService)
        let controller = SettingsViewController(viewModel: viewModel)
        viewModel.routeToAuthentication
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinatorFinishPublisher.send()
            }
            .store(in: &bindings)
        navigationController.setViewControllers([controller], animated: true)
    }
    
    override func finish() {
        bindings.removeAll()
    }
}
