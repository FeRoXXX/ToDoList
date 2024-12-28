//
//  SignUpViewModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 19.12.2024.
//

import Foundation
import Combine

final class SignUpViewModel {
    
    //MARK: - Private properties
    
    private(set) var navigateToSignInPublisher: PassthroughSubject<Void, Never> = .init()
    private(set) var navigateToHomePublisher: PassthroughSubject<UUID, Never> = .init()
    private(set) var showErrorPublisher: PassthroughSubject<String, Never> = .init()
    private let authService: AuthService?
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(authService: AuthService?) {
        self.authService = authService
        bind()
    }
}

//MARK: - Private extension

private extension SignUpViewModel {
    
    //MARK: - Bind
    
    func bind() {
        authService?.servicePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] types in
                switch types {
                case .signUp(let data):
                    self?.navigateToHomePublisher.send(data)
                case .error(let error):
                    if let error = error as? AuthService.Errors {
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

extension SignUpViewModel {
    
    //MARK: - Go to sign in view
    
    func goToSignInView() {
        navigateToSignInPublisher.send()
    }
    
    //MARK: - Sign up
    
    func signUp(fullName: String?, email: String?, password: String?) {
        authService?.signUp(SignUpModel(fullName: fullName, email: email, password: password))
    }
}
