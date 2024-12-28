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
    
    @Published var pushTaskDetails: TaskDetailsModel?
    @Published var pushTaskDetailsError: String?
    private(set) var cancelNewTaskModule: PassthroughSubject<Void, Never> = .init()
    private var profileDataService: ProfileDataService
    private var taskId: UUID?
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(profileDataService: ProfileDataService, taskId: UUID? = nil) {
        self.profileDataService = profileDataService
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
            .sink { [weak self] type in
                switch type {
                case .createTasks:
                    self?.profileDataService.getUserTasks()
                    self?.cancelNewTaskModule.send()
                case .error(let error):
                    self?.pushTaskDetailsError = error.message
                default:
                    break
                }
            }
            .store(in: &bindings)

        profileDataService.servicePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] types in
                switch types {
                case .taskDetails(let data):
                    let dateAndTime = data.endDate.formattedForDisplayDateAndTimeInTextField()
                    self?.pushTaskDetails = TaskDetailsModel(title: data.title,
                                                             date: dateAndTime.0,
                                                             time: dateAndTime.1,
                                                             description: data.noteDescription,
                                                             isDone: data.isDone)
                case .updateTaskResult:
                    self?.profileDataService.getUserTasks()
                    if let taskId = self?.taskId {
                        self?.profileDataService.getTaskById(taskId)
                    }
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
            let isDone = pushTaskDetails?.isDone
            profileDataService.updateTaskById(TaskModel(id: taskId,
                                                        title: task.title,
                                                        description: task.description,
                                                        endDate: endDate,
                                                        isDone: isDone ?? false))
        } else {
            profileDataService.createTask(TaskModel(title: task.title,
                                                    description: task.description,
                                                    endDate: endDate))
        }
    }
    
    //MARK: - Cancel task creation
    
    func cancelTaskCreation() {
        cancelNewTaskModule.send()
    }
}
