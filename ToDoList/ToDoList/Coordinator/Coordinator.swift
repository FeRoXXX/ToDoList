//
//  Coordinator.swift
//  ToDoList
//
//  Created by Александр Федоткин on 18.12.2024.
//

import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
