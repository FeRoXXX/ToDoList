//
//  ProfileDataService.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import Foundation
import Combine

final class ProfileDataService {
    
    enum Errors: Error {
        case emptyString
        case badEmail
        case badPassword
        case badFullName
        case alreadyExists
        
        var message: String {
            switch self {
            case .emptyString:
                return "Fill in all the fields!"
            case .badEmail:
                return "Enter a valid email!"
            case .badPassword:
                return "Password must contain at least 6 characters!"
            case .badFullName:
                return "Full name must contain only alphabetical characters!"
            case .alreadyExists:
                return "User already exists!"
            }
        }
    }
    
    //MARK: - Subscribers
    
    enum SubscribersType {
        case userProfileData(UserPublicDataModel)
        case userTasks([UserModel])
        case taskDetails(UserModel)
        case tasksByDate([UserModel])
        case createTasks
        case deleteTaskResult
        case updateTaskStatusResult
        case updateTaskResult
        case logoutResult
        case error(Errors)
        case dataBaseError(CoreDataService.Errors)
    }
    
    //MARK: - Private properties
    
    private(set) var servicePublisher: PassthroughSubject<SubscribersType, Never> = PassthroughSubject()
    private var userDefaultsService: UserDefaultsService
    private var coreDataService: CoreDataService
    private var authenticationKey: UUID
    
    //MARK: - Initialization
    
    init(authenticationKey: UUID, userDefaultService: UserDefaultsService, coreDataService: CoreDataService) {
        self.authenticationKey = authenticationKey
        self.userDefaultsService = userDefaultService
        self.coreDataService = coreDataService
    }
    
    //MARK: - Get email and full name by user id
    
    func getEmailAndFullName() {
        let result = coreDataService.getUserPublicData(by: authenticationKey)
        
        switch result {
        case .success(let success):
            servicePublisher.send(.userProfileData(success))
        case .failure(let failure):
            servicePublisher.send(.dataBaseError(failure))
        }
    }
    
    //MARK: - Get all tasks by user id
    
    func getUserTasks() {
        
        let result = coreDataService.getSortedTasks(by: authenticationKey)
        
        switch result {
        case .success(let success):
            servicePublisher.send(.userTasks(success))
        case .failure(let failure):
            servicePublisher.send(.dataBaseError(failure))
        }
    }
    
    //MARK: - Create new task
    
    func createTask(_ task: TaskModel) {
        guard let title = task.title,
              let description = task.description,
              let endDate = task.endDate else {
            
            servicePublisher.send(.error(.emptyString))
            return
        }
        
        let result = coreDataService.createTask(TaskRequestModel(id: task.id,
                                                                        title: title,
                                                                        description: description,
                                                                        endDate: endDate,
                                                                        isDone: task.isDone,
                                                                        relationshipId: authenticationKey))
        if result {
            servicePublisher.send(.createTasks)
        }
    }
    
    //MARK: - Get task detail by task id
    
    func getTaskById(_ taskId: UUID)  {
        let result = coreDataService.getTaskDetailsById(taskId)
        
        if let result {
            servicePublisher.send(.taskDetails(result))
        }
    }
    
    //MARK: - Delete task by id
    
    func deleteTaskById(_ taskId: UUID) {
        let result = coreDataService.deleteTaskById(taskId)
        
        if result {
            servicePublisher.send(.deleteTaskResult)
        }
    }
    
    //MARK: - Update task status by id
    
    func updateTaskStatusById(_ taskId: UUID) {
        let result = coreDataService.updateTaskStatusById(taskId)
        
        if result {
            servicePublisher.send(.updateTaskStatusResult)
        }
    }
    
    //MARK: - Logout
    
    func logout() {
        userDefaultsService.deleteAuthorizationState()
        servicePublisher.send(.logoutResult)
    }
    
    //MARK: - Get task by date
    
    func getTaskByDate(date: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            servicePublisher.send(.dataBaseError(.doesNotExist))
            return
        }
        
        let result = coreDataService.getTaskByDate(startOfDay, endOfDay, userId: authenticationKey)
        
        switch result {
        case .success(let success):
            servicePublisher.send(.tasksByDate(success))
        case .failure(let failure):
            servicePublisher.send(.dataBaseError(failure))
        }
    }
    
    //MARK: - Update task by id
    
    func updateTaskById(_ task: TaskModel) {
        guard let title = task.title,
              !title.isEmpty,
              let description = task.description,
              !description.isEmpty,
              description != "Description",
              let endDate = task.endDate
        else {
            servicePublisher.send(.error(.emptyString))
            return
        }
        
        let result = coreDataService.updateTaskByData(TaskRequestModel(id: task.id,
                                                                       title: title,
                                                                       description: description,
                                                                       endDate: endDate,
                                                                       isDone: task.isDone,
                                                                       relationshipId: authenticationKey))
        if result {
            servicePublisher.send(.updateTaskResult)
        }
    }
}
