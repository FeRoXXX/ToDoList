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
    private(set) var routeToTaskDetails: PassthroughSubject<UUID, Never> = .init()
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
        bind()
        profileDataService.getUserIncompleteTasks(userId: userId)
    }
    
    //MARK: - bind
    
    func bind() {
        profileDataService.servicePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                print(error)
            } receiveValue: { [weak self] type in
                switch type {
                case .incompleteTasks(let data):
                    let incompleteTasks = data.map {ToDoListModel(taskId: $0.id,
                                                                  title: $0.title,
                                                                  date: $0.endDate.formattedForDisplay(),
                                                                  isComplete: $0.isDone)}
                    
                    self?.pushTableViewData.send(incompleteTasks)
                default:
                    return
                }
            }
            .store(in: &bindings)
    }
    
    //MARK: - Navigate to addNewNote
    
    func navigateToAddNewTask() {
        navigateToAddNew.send()
    }
    
    func navigateToTaskDetails(taskId: UUID) {
        routeToTaskDetails.send(taskId)
    }
}
