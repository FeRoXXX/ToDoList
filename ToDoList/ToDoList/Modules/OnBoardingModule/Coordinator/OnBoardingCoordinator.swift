//
//  OnBoardingCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 19.12.2024.
//

import UIKit
import Combine

final class OnBoardingCoordinator: Coordinator {
    
    //MARK: - Private properties
    
    private(set) var didFinish: PassthroughSubject<Void, Never> = .init()
    private var pages: [OnBoardingViewController] = [OnBoardingViewController(),
                                             OnBoardingViewController(),
                                             OnBoardingViewController(),
                                             OnBoardingViewController()
    ]
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        let viewModel = OnBoardingMainViewModel(totalPages: pages.count)
        viewModel.routeToAuthentication
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.didFinish.send()
            }
            .store(in: &bindings)
        let controller = OnBoardingMainViewController(viewModel: viewModel, pages: pages)
        navigationController.setViewControllers([controller], animated: true)
    }
    
    override func finish() {
        pages.removeAll()
        bindings.removeAll()
    }
}
