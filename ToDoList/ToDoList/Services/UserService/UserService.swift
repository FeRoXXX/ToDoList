//
//  UserService.swift
//  ToDoList
//
//  Created by Александр Федоткин on 20.12.2024.
//

import UIKit
import CoreData
import Combine

final class UserService {
    
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
    
    static let shared = UserService()
    
    private var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        return appDelegate
    }
    
    private var context: NSManagedObjectContext {
        return DispatchQueue.main.sync {
                return appDelegate.persistentContainer.viewContext
            }
    }
}

extension UserService {
    
    //MARK: - Create object method
    
    func createObject(_ data: SignUpRequestModel) -> Result<AuthModel, Error> {
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
        
        return .success(user)
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
    
    func getUserData(by data: SignInRequestModel) -> Result<AuthModel, Error> {
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
            return .success(data)
        } catch {
            return .failure(Errors.badDecode)
        }
    }
}
