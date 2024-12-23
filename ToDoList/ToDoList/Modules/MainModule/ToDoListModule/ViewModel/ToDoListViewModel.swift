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
    
    private(set) var pushTableViewData: PassthroughSubject<[ToDoListModel], Never> = .init()
    private(set) var navigateToAddNew: PassthroughSubject<Void, Never> = .init()
    private var bindings: Set<AnyCancellable> = []
    private var userId: UUID
    private var profileDataService: ProfileDataService
    
    //MARK: - Initialization
    
    init(userId: UUID, profileDataService: ProfileDataService) {
        self.userId = userId
        self.profileDataService = profileDataService
    }
}

//MARK: - Private extension

private extension ToDoListViewModel {
    
}

//MARK: - Public extension

extension ToDoListViewModel {
    
    //MARK: - didLoad
    
    func loadData() {
        requestTableViewData()
    }
    
    //MARK: - Request Table view data
    
    func requestTableViewData() {
        profileDataService.getUserIncompleteTasks(userId: userId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                print(error)
            } receiveValue: { [weak self] data in
                let incompleteTasks = data.map {ToDoListModel(title: $0.title,
                                                             date: $0.endDate.formattedForDisplay(),
                                                             isComplete: $0.isDone)}
                
                self?.pushTableViewData.send(incompleteTasks)
            }
            .store(in: &bindings)
    }
    
    //MARK: - Navigate to addNewNote
    
    func navigateToAddNewTask() {
        navigateToAddNew.send()
    }
}
