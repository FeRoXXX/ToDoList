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
        case incompleteTasks([UserModel])
        case userTasks([UserModel])
        case taskDetails(UserModel)
        case createTasks
        case deleteTaskResult
        case updateTaskResult
        case logoutResult
    }
    
    //MARK: - Static properties
    
    static var shared: ProfileDataService = ProfileDataService()
    
    //MARK: - Private properties
    
    private(set) var servicePublisher: PassthroughSubject<SubscribersType, Error> = PassthroughSubject()
    private var userDefaultsService: UserDefaultsService = UserDefaultsService()
    private var coreDataService: CoreDataService = CoreDataService.shared
    
    //MARK: - Initialization
    
    private init() {}
    
    //MARK: - Get email and full name by user id
    
    func getEmailAndFullName(by id: UUID) {
        let result = CoreDataService.shared.getUserPublicData(by: id)
        
        switch result {
        case .success(let success):
            servicePublisher.send(.userProfileData(success))
        case .failure(let failure):
            return
        }
    }
    
    //MARK: - Get all tasks by user id
    
    func getUserTasksByUserId(_ id: UUID) {
        
        let result = CoreDataService.shared.getSortedTasks(by: id)
        
        switch result {
        case .success(let success):
            servicePublisher.send(.userTasks(success))
        case .failure(let failure):
            return
        }
    }
    
    //MARK: - Create new task
    
    func createTask(_ task: TaskModel) {
        guard let title = task.title,
              let description = task.description,
              let endDate = task.endDate,
              let relationshipId = task.relationshipId else {
            
            return
        }
        
        let result = CoreDataService.shared.createTask(TaskRequestModel(title: title,
                                                                        description: description,
                                                                        endDate: endDate,
                                                                        isDone: task.isDone,
                                                                        relationshipId: relationshipId))
        if result {
            servicePublisher.send(.createTasks)
        }
    }
    
    //MARK: - Get incomplete task by user id
    
    func getUserIncompleteTasks(userId: UUID){
        let result = CoreDataService.shared.getSortedIncompleteTasks(by: userId)
        
        switch result {
        case .success(let success):
            servicePublisher.send(.incompleteTasks(success))
        case .failure(let failure):
            return
        }
    }
    
    //MARK: - Get task detail by task id
    
    func getTaskById(_ taskId: UUID)  {
        let result = CoreDataService.shared.getTaskDetailsById(taskId)
        
        guard let result else { return }
        
        servicePublisher.send(.taskDetails(result))
    }
    
    //MARK: - Delete task by id
    
    func deleteTaskById(_ taskId: UUID) {
        let result = CoreDataService.shared.deleteTaskById(taskId)
        
        if result {
            servicePublisher.send(.deleteTaskResult)
        }
    }
    
    //MARK: - Update task by id
    
    func updateTaskById(_ taskId: UUID) {
        let result = CoreDataService.shared.updateTaskById(taskId)
        
        if result {
            servicePublisher.send(.updateTaskResult)
        }
    }
    
    //MARK: - Logout
    
    func logout(user: UUID) {
        userDefaultsService.deleteAuthorizationState()
        servicePublisher.send(.logoutResult)
    }
}
