//
//  NewTaskViewModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 24.12.2024.
//

import Foundation
import Combine

final class NewTaskViewModel {
    
    //MARK: - Private properties
    
    private var bindings: Set<AnyCancellable> = []
    private(set) var cancelNewTaskModule: PassthroughSubject<Void, Never> = .init()
    private(set) var pushTaskDetails: PassthroughSubject<TaskDetailsModel, Never> = .init()
    private var profileDataService: ProfileDataService
    private var taskId: UUID?
    private var authenticationKey: UUID
    
    //MARK: - Initialization
    
    init(profileDataService: ProfileDataService, authenticationKey: UUID, taskId: UUID? = nil) {
        self.profileDataService = profileDataService
        self.authenticationKey = authenticationKey
        self.taskId = taskId
    }
}

//MARK: - Private extension

private extension NewTaskViewModel {
    
    //MARK: - Date and time formatter
    
    func combineDateAndTime(dateString: String?, timeString: String?) -> Date? {
        guard let dateString,
              let timeString else { return nil }
        let combinedFormat = "dd/MM/yyyy HH:mm"
        
        let combinedString = "\(dateString) \(timeString)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = combinedFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.date(from: combinedString)
    }
    
    //MARK: - Bind
    
    func bind() {
        
        profileDataService.servicePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                print(error)
            } receiveValue: { [weak self] type in
                switch type {
                case .createTasks:
                    if let authenticationKey = self?.authenticationKey {
//                        self?.profileDataService.getUserIncompleteTasks(userId: authenticationKey)
                        self?.profileDataService.getUserTasksByUserId(authenticationKey)
                        self?.cancelNewTaskModule.send()
                    }
                default:
                    break
                }
            }
            .store(in: &bindings)

        profileDataService.servicePublisher
            .receive(on: DispatchQueue.main)
            .sink { error in
                
            } receiveValue: { [weak self] types in
                switch types {
                case .taskDetails(let data):
                    let dateAndTime = data.endDate.formattedForDisplayDateAndTime()
                    self?.pushTaskDetails.send(TaskDetailsModel(title: data.title,
                                                                date: dateAndTime.0,
                                                                time: dateAndTime.1,
                                                                description: data.noteDescription))
                case .updateTaskResult:
                    self?.cancelNewTaskModule.send()
                default:
                    break
                }
            }
            .store(in: &bindings)
    }
}

//MARK: - Public extension

extension NewTaskViewModel {
    
    //MARK: - view did load
    
    func viewLoaded() {
        bind()
        if let taskId {
            profileDataService.getTaskById(taskId)
        }
    }
    
    //MARK: - Create new task
    
    func pushTaskData(_ task: NewTaskDataModel) {
        let endDate = combineDateAndTime(dateString: task.date, timeString: task.time)
        if let taskId {
            profileDataService.updateTaskById(TaskModel(id: taskId,
                                                        title: task.title,
                                                        description: task.description,
                                                        endDate: endDate,
                                                        relationshipId: authenticationKey))
        } else {
            profileDataService.createTask(TaskModel(title: task.title,
                                                    description: task.description,
                                                    endDate: endDate,
                                                    relationshipId: authenticationKey))
        }
    }
    
    //MARK: - Cancel task creation
    
    func cancelTaskCreation() {
        cancelNewTaskModule.send()
    }
}
