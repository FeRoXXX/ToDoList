//
//  SignInViewModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 19.12.2024.
//

import Foundation
import Combine

final class SignInViewModel {
    
    enum Constants: String {
        case title = "Welcome Back to DO IT "
        case support = "Have an other productive day !"
        case emailPlaceholder = "E-mail"
        case passwordPlaceholder = "Password"
        case signUpButtonTitle = "Sign in"
        case additionalInfo = "Don’t have an account? sign up"
    }
    
    //MARK: - Private properties
    
    private(set) var pushStaticTextPublisher: PassthroughSubject<SignInStaticText, Never> = .init()
    private(set) var navigateToSignUpPublisher: PassthroughSubject<Void, Never> = .init()
    private(set) var showErrorPublisher: PassthroughSubject<String, Never> = .init()
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init() {}
}

//MARK: - Private extension

private extension SignInViewModel {
    
    //MARK: - Prepare constants data
    
    func prepareConstants() {
        pushStaticTextPublisher
            .send(SignInStaticText(title: Constants.title.rawValue.toAttributedString(highlighting: "DO IT",
                                                                                      defaultFont: .init(name: "Poppins-Medium", size: 25),
                                                                                      highlightedFont: .init(name: "DarumadropOne-Regular", size: 25)),
                                   support: Constants.support.rawValue,
                                   emailPlaceholder: Constants.emailPlaceholder.rawValue,
                                   passwordPlaceholder: Constants.passwordPlaceholder.rawValue,
                                   signInButtonTitle: Constants.signUpButtonTitle.rawValue,
                                   additionalInfo: Constants.additionalInfo.rawValue.toAttributedString(highlighting: "sign up",
                                                                                                        defaultFont: .init(name: "Poppins-Medium", size: 14),
                                                                                                        highlightedFont: .init(name: "Poppins-Medium", size: 14),
                                                                                                        alignment: .center,
                                                                                                        additionalColor: #colorLiteral(red: 0.3882352941, green: 0.8509803922, blue: 0.9529411765, alpha: 1))))
    }
}

//MARK: - Public extension

extension SignInViewModel {
    
    //MARK: - Load constants
    
    func loadConstants() {
        prepareConstants()
    }
    
    //MARK: - Go to sign in view
    
    func goToSignUpView() {
        navigateToSignUpPublisher.send()
    }
    
    //MARK: - Sign in function
    
    func checkAuthData(email: String?, password: String?) {
        //MARK: - FIXME Тут стакаются подписки
        AuthService.shared.signIn(SignInModel(email: email, password: password))
            .first()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                switch error {
                case .failure(let value):
                    if let value = value as? AuthService.Errors {
                        self?.showErrorPublisher.send(value.message)
                    } else if let value = value as? UserService.Errors {
                        self?.showErrorPublisher.send(value.message)
                    }
                case .finished:
                    break
                }
            } receiveValue: { _ in
                
            }
            .store(in: &bindings)
    }
}


