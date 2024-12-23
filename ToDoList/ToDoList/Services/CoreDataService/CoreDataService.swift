//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Александр Федоткин on 20.12.2024.
//

import UIKit
import CoreData
import Combine

final class CoreDataService {
    
    enum Errors: Error {
        case dataBaseError
        case badDecode
        case badDescription
        case doesNotExist
        
        var message: String {
            switch self {
            case .dataBaseError:
                return "Database error"
            case .badDescription:
                return "Bad description"
            case .badDecode:
                return "Bad decode"
            case .doesNotExist:
                return "User does not exist!"
            }
        }
    }
    
    static let shared = CoreDataService()
    
    private var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        return appDelegate
    }
    
    private var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}

extension CoreDataService {
    
    //MARK: - Create object method
    
    func createUser(_ data: SignUpRequestModel) -> Result<UUID, Error> {
        defer {
            appDelegate.saveContext()
        }
        
        guard let authEntityDescription = NSEntityDescription.entity(forEntityName: "AuthModel", in: context) else {
            return .failure(Errors.dataBaseError)
        }
        let user = AuthModel(entity: authEntityDescription, insertInto: context)
        user.id = UUID()
        user.email = data.email
        user.password = data.password
        user.fullName = data.fullName
        
        return .success(user.id)
    }
    
    func createTask(_ taskData: TaskRequestModel) -> Bool {
        defer {
            appDelegate.saveContext()
        }
        
        guard let userEntityDescription = NSEntityDescription.entity(forEntityName: "UserModel", in: context) else {
            return false
        }
        let user = UserModel(entity: userEntityDescription, insertInto: context)
        user.id = UUID()
        user.title = taskData.title
        user.noteDescription = taskData.description
        user.endDate = taskData.endDate
        user.isDone = taskData.isDone
        user.relationship = taskData.relationship
        return true
    }
    
    func getSortedTasks(by userId: UUID) -> Result<[UserModel], Error> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserModel")
        let relationshipPredicate = NSPredicate(format: "relationship.id = %@", userId as CVarArg)
        fetchRequest.predicate = relationshipPredicate
        
        let sortDescriptor = NSSortDescriptor(key: "endDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let data = (try context.fetch(fetchRequest) as? [UserModel]) ?? []
            return .success(data)
        } catch {
            return .failure(Errors.badDecode)
        }
    }
    
    func getSortedIncompleteTasks(by userId: UUID) -> Result<[UserModel], Error> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserModel")
        let relationshipPredicate = NSPredicate(format: "relationship.id = %@", userId as CVarArg)
        let incompletePredicate = NSPredicate(format: "isDone = %@", false)
        fetchRequest.predicate = relationshipPredicate
        
        let sortDescriptor = NSSortDescriptor(key: "endDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let data = (try context.fetch(fetchRequest) as? [UserModel]) ?? []
            return .success(data)
        } catch {
            return .failure(Errors.badDecode)
        }
    }
    
    //MARK: - Check user already sign up
    
    func checkUserExist(by data: SignInRequestModel) -> Result<Bool, Error> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AuthModel")
        let emailPredicate = NSPredicate(format: "email = %@", data.email)
        let passwordPredicate = NSPredicate(format: "password = %@", data.password)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [emailPredicate, passwordPredicate])
        fetchRequest.predicate = andPredicate
        do {
            let data = (try context.fetch(fetchRequest) as? [AuthModel]) ?? []
            if data.isEmpty {
                return .success(false)
            } else {
                return .success(true)
            }
        } catch {
            return .failure(Errors.badDecode)
        }
    }
    
    //MARK: - Get user by sign in data
    
    func getUserID(by data: SignInRequestModel) -> Result<UUID, Error> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AuthModel")
        let emailPredicate = NSPredicate(format: "email = %@", data.email)
        let passwordPredicate = NSPredicate(format: "password = %@", data.password)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [emailPredicate, passwordPredicate])
        fetchRequest.predicate = andPredicate
        do {
            let data = (try context.fetch(fetchRequest) as? [AuthModel]) ?? []
            guard let data = data.first else {
                return .failure(Errors.doesNotExist)
            }
            
            return .success(data.id)
        } catch {
            return .failure(Errors.badDecode)
        }
    }
    
    //MARK: - Get email and fullName
    
    func getUserPublicData(by id: UUID) -> Result<UserPublicDataModel, Error> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AuthModel")
        let idPredicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        fetchRequest.predicate = idPredicate
        fetchRequest.propertiesToFetch = ["email", "fullName"]
        fetchRequest.resultType = .dictionaryResultType
        
        do {
            let results = try context.fetch(fetchRequest)
            
            guard let firstResult = results.first as? [String: Any],
                  let email = firstResult["email"] as? String,
                  let fullName = firstResult["fullName"] as? String else {
                return .failure(Errors.doesNotExist)
            }
            
            let userPublicData = UserPublicDataModel(fullName: fullName, email: email)
            return .success(userPublicData)
        } catch {
            return .failure(Errors.badDecode)
        }
    }
}
