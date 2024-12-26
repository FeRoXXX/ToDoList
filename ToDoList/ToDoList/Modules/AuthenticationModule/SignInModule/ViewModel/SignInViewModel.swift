//
//  SignInViewModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 19.12.2024.
//

import Foundation
import Combine

final class SignInViewModel {
    
    //MARK: - Private properties
    
    private(set) var navigateToSignUpPublisher: PassthroughSubject<Void, Never> = .init()
    private(set) var navigateToHomePublisher: PassthroughSubject<UUID, Never> = .init()
    private(set) var showErrorPublisher: PassthroughSubject<String, Never> = .init()
    private var authService: AuthService?
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(authService: AuthService?) {
        self.authService = authService
        bind()
    }
}

//MARK: - Private extension

private extension SignInViewModel {
    
    //MARK: - Bind
    
    func bind() {
        authService?.servicePublisher
            .receive(on: DispatchQueue.main)
            .first()
            .sink { _ in
                
            } receiveValue: { [weak self] types in
                switch types {
                case .signIn(let id):
                    self?.navigateToHomePublisher.send(id)
                case .error(let error):
                    if let error = error as? AuthService.Errors {
                        self?.showErrorPublisher.send(error.message)
                    } else if let error = error as? CoreDataService.Errors {
                        self?.showErrorPublisher.send(error.message)
                    }
                default:
                    break
                }
            }
            .store(in: &bindings)

    }
}

//MARK: - Public extension

extension SignInViewModel {
    
    //MARK: - Go to sign in view
    
    func goToSignUpView() {
        navigateToSignUpPublisher.send()
    }
    
    //MARK: - Sign in
    
    func signIn(email: String?, password: String?) {
        authService?.signIn(SignInModel(email: email, password: password))
    }
}


