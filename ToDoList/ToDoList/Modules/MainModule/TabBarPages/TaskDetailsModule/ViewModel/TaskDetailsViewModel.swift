//
//  TaskDetailsViewModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 24.12.2024.
//

import Foundation
import Combine

final class TaskDetailsViewModel {
    
    enum Navigation {
        case back
        case newTask
    }
    
    //MARK: - Private properties
    
    @Published var pushTaskDetails: TaskDetailsModel?
    private(set) var navigation: PassthroughSubject<Navigation, Never> = .init()
    private let taskId: UUID
    private let profileDataService: ProfileDataService
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
            .receive(on: DispatchQueue.global())
            .sink { [weak self] type in
                switch type {
                case .taskDetails(let value):
                    let dateAndTime = value.endDate.formattedForDisplayDateAndTime()
                    self?.pushTaskDetails = TaskDetailsModel(title: value.title,
                                                             date: dateAndTime.0,
                                                             time: dateAndTime.1,
                                                             description: value.noteDescription,
                                                             isDone: value.isDone)
                default:
                    break
                }
            }
            .store(in: &bindings)
        
        profileDataService.servicePublisher
            .receive(on: DispatchQueue.global())
            .sink { [weak self] type in
                switch type {
                case .deleteTaskResult:
                    self?.navigation.send(.back)
                default:
                    break
                }
            }
            .store(in: &bindings)
        
        profileDataService.servicePublisher
            .receive(on: DispatchQueue.global())
            .sink { [weak self] type in
                switch type {
                case .updateTaskStatusResult:
                    guard let taskId = self?.taskId else { return }
                    self?.profileDataService.getTaskById(taskId)
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
        self.navigation.send(.back)
    }
    
    func correctButtonDidTap() {
        self.navigation.send(.newTask)
    }
}
