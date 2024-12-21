//
//  Coordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 18.12.2024.
//

import UIKit

class Coordinator: AnyObject {
    
    //MARK: - Public properties
    
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    //MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: - Start function
    
    func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    func finish() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
}

extension Coordinator {
    
    //MARK: - Add coordinator function
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        children.append(coordinator)
    }
    
    //MARK: - Did finish coordinator
    
    func removeChild(_ coordinator: Coordinator) {
        if let index = children.firstIndex(of: coordinator) {
            children.remove(at: index)
        }
    }
}

//MARK: - Equatable

extension Coordinator: Equatable {
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
}
