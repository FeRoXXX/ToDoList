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
    
    //MARK: - Static properties
    
    static var shared: ProfileDataService = ProfileDataService()
    
    //MARK: - Initialization
    
    private init() {}
    
    func getEmailAndFullName(by id: UUID) -> AnyPublisher<UserPublicDataModel, Error> {
        let result = CoreDataService.shared.getUserPublicData(by: id)
        
        switch result {
        case .success(let success):
            return Result.Publisher(success)
                .eraseToAnyPublisher()
        case .failure(let failure):
            return Result.Publisher(failure)
                .eraseToAnyPublisher()
        }
    }
    
    func getUserTasksByUserId(_ id: UUID) -> AnyPublisher<[UserModel], Error> {
        
        let result = CoreDataService.shared.getSortedTasks(by: id)
        
        switch result {
        case .success(let success):
            return Result.Publisher(success)
                .eraseToAnyPublisher()
        case .failure(let failure):
            return Result.Publisher(failure)
                .eraseToAnyPublisher()
        }
    }
    
    func createTask(_ task: TaskModel) -> AnyPublisher<Bool, Error> {
        guard let title = task.title,
              let description = task.description,
              let endDate = task.endDate,
              let relationship = task.relationship else {
            return Fail(error: Errors.emptyString)
                .eraseToAnyPublisher()
        }
        
        let result = CoreDataService.shared.createTask(TaskRequestModel(title: title,
                                                           description: description,
                                                           endDate: endDate,
                                                           isDone: task.isDone,
                                                           relationship: relationship))
        return Result.Publisher(result)
            .eraseToAnyPublisher()
    }
}
