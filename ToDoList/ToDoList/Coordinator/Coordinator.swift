//
//  Coordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 18.12.2024.
//

import UIKit

protocol Coordinator: AnyObject {
    
    //MARK: - Public properties
    
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    //MARK: - Start function
    
    func start()
}

extension Coordinator {
    
    //MARK: - Add coordinator function
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        children.append(coordinator)
    }
    
    //MARK: - Did finish coordinator
    
    func didFinish(_ coordinator: Coordinator) {
        children = children.filter { $0 !== coordinator }
    }
}
