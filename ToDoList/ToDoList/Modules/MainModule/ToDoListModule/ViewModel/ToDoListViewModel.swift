//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import Foundation
import Combine

final class ToDoListViewModel {
    
    //MARK: - Private properties
    
    private(set) var navigateToAddItem: PassthroughSubject<Void, Never> = .init()
}

//MARK: - Public extension

extension ToDoListViewModel {
    
    func navigateToAddToDoItem() {
        navigateToAddItem.send()
    }
}
