//
//  NewNoteCoordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import UIKit
import Combine

final class NewNoteCoordinator: Coordinator {
    
    //MARK: - Initialization
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    //MARK: - Override functions
    
    override func start() {
        let controller = NewNoteViewController()
        controller.modalTransitionStyle = .coverVertical
        controller.modalPresentationStyle = .overFullScreen
        navigationController.present(controller, animated: true)
    }
    
    override func finish() {
        
    }
}
