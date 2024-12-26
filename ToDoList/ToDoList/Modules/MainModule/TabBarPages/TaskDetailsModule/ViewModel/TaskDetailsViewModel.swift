//
//  TaskDetailsViewModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 24.12.2024.
//

import Foundation
import Combine

final class TaskDetailsViewModel {
    
    //MARK: - Private properties
    
    private let taskId: UUID
    private let profileDataService: ProfileDataService
    private(set) var pushTaskDetails: PassthroughSubject<TaskDetailsModel, Never> = .init()
    private(set) var routeToBack: PassthroughSubject<Void, Never> = .init()
    private(set) var routeToNewTask: PassthroughSubject<Void, Never> = .init()
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(taskId: UUID, profileDataService: ProfileDataService) {
        self.taskId = taskId
        self.profileDataService = profileDataService
    }
}

//MARK: - Private extension

private extension TaskDetailsViewModel {
    
    //MARK: - Bind
    func bind() {
        profileDataService.servicePublisher
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] type in
                switch type {
                case .taskDetails(let value):
                    let dateAndTime = value.endDate.formattedForDisplayDateAndTime()
                    self?.pushTaskDetails.send(TaskDetailsModel(title: value.title,
                                                                date: dateAndTime.0,
                                                                time: dateAndTime.1,
                                                                description: value.noteDescription,
                                                                isDone: value.isDone))
                default:
                    break
                }
            }
            .store(in: &bindings)
        
        profileDataService.servicePublisher
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] type in
                switch type {
                case .deleteTaskResult:
                    self?.routeToBack.send()
                default:
                    break
                }
            }
            .store(in: &bindings)
        
        profileDataService.servicePublisher
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] type in
                switch type {
                case .updateTaskStatusResult:
                    self?.routeToBack.send()
                default:
                    break
                }
            }
            .store(in: &bindings)
    }
}

//MARK: - Public extension

extension TaskDetailsViewModel {
    
    //MARK: - Load data function
    
    func loadData() {
        bind()
        profileDataService.getTaskById(taskId)
    }
    
    //MARK: - binding function
    
    func deleteTaskById() {
        profileDataService.deleteTaskById(taskId)
    }
    
    func updateTaskById() {
        profileDataService.updateTaskStatusById(taskId)
    }
    
    func navigateToBack() {
        routeToBack.send()
    }
    
    func correctButtonDidTap() {
        routeToNewTask.send()
    }
}
