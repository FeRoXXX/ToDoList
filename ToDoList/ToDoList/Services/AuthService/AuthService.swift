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
    
    enum SubscribersType {
        case signUp(UUID)
        case signIn(UUID)
        case error(Error)
    }
    
    //MARK: - Private properties
    
    private(set) var servicePublisher: PassthroughSubject<SubscribersType, Never> = PassthroughSubject()
    private var coreDataService: CoreDataService
    
    //MARK: - Initialization
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    //MARK: - Sign up
    
    func signUp(_ data: SignUpModel){
        guard let fullName = data.fullName,
              let email = data.email,
              let password = data.password,
              !fullName.isEmpty,
              !email.isEmpty,
              !password.isEmpty
        else {
            servicePublisher.send(.error(Errors.emptyString))
            return
        }
        
        guard isValidFullName(fullName) else {
            servicePublisher.send(.error(Errors.badFullName))
            return
        }
        
        guard isValidEmail(email) else {
            servicePublisher.send(.error(Errors.badEmail))
            return
        }
        
        guard isValidPassword(password) else {
            servicePublisher.send(.error(Errors.badPassword))
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let result = coreDataService.checkUserExist(by: SignInRequestModel(email: email, password: password))
            switch result {
            case .success(let success):
                if success {
                    servicePublisher.send(.error(Errors.alreadyExists))
                } else {
                    let result = coreDataService.createUser(SignUpRequestModel(email: email,
                                                                               fullName: fullName,
                                                                               password: password))
                    
                    switch result {
                    case .success(let success):
                        servicePublisher.send(.signUp(success))
                    case .failure(let failure):
                        servicePublisher.send(.error(failure))
                    }
                }
            case .failure(_):
                let result = coreDataService.createUser(SignUpRequestModel(email: email,
                                                                           fullName: fullName,
                                                                           password: password))
                switch result {
                case .success(let success):
                    servicePublisher.send(.signUp(success))
                case .failure(let failure):
                    servicePublisher.send(.error(failure))
                }
            }
        }
    }
    
    //MARK: - Sign in
    
    func signIn(_ data: SignInModel) {
        guard let email = data.email,
              let password = data.password,
              !email.isEmpty,
              !password.isEmpty
        else {
            servicePublisher.send(.error(Errors.emptyString))
            return
        }
        
        guard isValidEmail(email) else {
            servicePublisher.send(.error(Errors.badEmail))
            return
        }
        
        guard isValidPassword(password) else {
            servicePublisher.send(.error(Errors.badPassword))
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let result = coreDataService.getUserID(by: SignInRequestModel(email: email, password: password))
            switch result {
            case .success(let success):
                servicePublisher.send(.signIn(success))
            case .failure(let failure):
                servicePublisher.send(.error(failure))
            }
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
