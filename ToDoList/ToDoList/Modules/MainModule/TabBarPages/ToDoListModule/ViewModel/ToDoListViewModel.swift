//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import Foundation
import Combine

final class ToDoListViewModel {
    
    enum Navigation {
        case toDetails(UUID)
        case toAddNew
    }
    
    //MARK: - Private properties
    
    @Published var tasksData: [ToDoListModel] = []
    private(set) var navigationPublisher: PassthroughSubject<Navigation, Never> = .init()
    private var bindings: Set<AnyCancellable> = []
    private var profileDataService: ProfileDataService
    
    //MARK: - Initialization
    
    init(profileDataService: ProfileDataService) {
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
        profileDataService.getUserTasks()
    }
    
    //MARK: - bind
    
    func bind() {
        profileDataService.servicePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                switch type {
                case .userTasks(let data):
                    let tasks = data.map { ToDoListModel(taskId: $0.id,
                                                         title: $0.title,
                                                         date: $0.endDate.formattedForDisplay(),
                                                         isComplete: $0.isDone)}
                    self?.tasksData = tasks
                default:
                    return
                }
            }
            .store(in: &bindings)
    }
    
    //MARK: - Navigate to addNewNote
    
    func navigateToAddNewTask() {
        navigationPublisher.send(.toAddNew)
    }
    
    func navigateToTaskDetails(taskId: UUID) {
        navigationPublisher.send(.toDetails(taskId))
    }
}
