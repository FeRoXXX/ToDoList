//
//  AuthService.swift
//  ToDoList
//
//  Created by Александр Федоткин on 20.12.2024.
//

import Foundation
import Combine

final class AuthService {
    
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
    
    static var shared: AuthService = AuthService()
    
    //MARK: - Initialization
    
    private init() {}
    
    //MARK: - Sign up
    
    func signUp(_ data: SignUpModel) -> AnyPublisher<UUID, Error> {
        guard let fullName = data.fullName,
              let email = data.email,
              let password = data.password,
              !fullName.isEmpty,
              !email.isEmpty,
              !password.isEmpty
        else {
            return Fail(error: Errors.emptyString)
                .eraseToAnyPublisher()
        }
        
        guard isValidFullName(fullName) else {
            return Fail(error: Errors.badFullName)
                .eraseToAnyPublisher()
        }
        
        guard isValidEmail(email) else {
            return Fail(error: Errors.badEmail)
                .eraseToAnyPublisher()
        }
        
        guard isValidPassword(password) else {
            return Fail(error: Errors.badPassword)
                .eraseToAnyPublisher()
        }
        
        let result = CoreDataService.shared.checkUserExist(by: SignInRequestModel(email: email, password: password))
        switch result {
        case .success(let success):
            if success {
                return Fail(error: Errors.alreadyExists)
                    .eraseToAnyPublisher()
            } else {
                let result = CoreDataService.shared.createUser(SignUpRequestModel(email: email,
                                                                   fullName: fullName,
                                                                   password: password))
                
                switch result {
                case .success(let success):
                    return Result.Publisher(success)
                        .eraseToAnyPublisher()
                case .failure(let failure):
                    return Result.Publisher(failure)
                        .eraseToAnyPublisher()
                }
            }
        case .failure(_):
            let result = CoreDataService.shared.createUser(SignUpRequestModel(email: email,
                                                               fullName: fullName,
                                                               password: password))
            switch result {
            case .success(let success):
                return Result.Publisher(success)
                    .eraseToAnyPublisher()
            case .failure(let failure):
                return Fail(error: failure)
                    .eraseToAnyPublisher()
            }
        }
    }
    
    func signIn(_ data: SignInModel) -> AnyPublisher<UUID, Error> {
        guard let email = data.email,
              let password = data.password,
              !email.isEmpty,
              !password.isEmpty
        else {
            return Fail(error: Errors.emptyString)
                .eraseToAnyPublisher()
        }
        
        guard isValidEmail(email) else {
            return Fail(error: Errors.badEmail)
                .eraseToAnyPublisher()
        }
        
        guard isValidPassword(password) else {
            return Fail(error: Errors.badPassword)
                .eraseToAnyPublisher()
        }
        
        let result = CoreDataService.shared.getUserID(by: SignInRequestModel(email: email, password: password))
        switch result {
        case .success(let success):
            return Result.Publisher(success)
                .eraseToAnyPublisher()
        case .failure(let failure):
            return Fail(error: failure)
                .eraseToAnyPublisher()
        }
    }
}

//MARK: - Private extension

private extension AuthService {
    
    //MARK: - Validation
    
    func isValidFullName(_ fullName: String) -> Bool {
        let fullNameRegex = "^[A-Za-z ]+$"
        return NSPredicate(format: "SELF MATCHES %@", fullNameRegex).evaluate(with: fullName)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let regex = "^.{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }
}
