//
//  SignUpViewModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 19.12.2024.
//

import Foundation
import Combine

final class SignUpViewModel {
    
    enum Constants: String {
        case title = "Welcome to DO IT"
        case support = "create an account and Join us now!"
        case fullNamePlaceholder = "Full name"
        case emailPlaceholder = "E-mail"
        case passwordPlaceholder = "Password"
        case signUpButtonTitle = "Sign up"
        case additionalInfo = "Already have an account? sign in"
    }
    
    //MARK: - Private properties
    
    private(set) var pushStaticTextPublisher: PassthroughSubject<SignUpStaticText, Never> = .init()
    private(set) var navigateToSignInPublisher: PassthroughSubject<Void, Never> = .init()
    private(set) var showErrorPublisher: PassthroughSubject<String, Never> = .init()
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init() {}
}

//MARK: - Private extension

private extension SignUpViewModel {
    
    //MARK: - Prepare constants data
    
    func prepareConstants() {
        pushStaticTextPublisher.send(SignUpStaticText(title: Constants.title.rawValue.toAttributedString(highlighting: "DO IT",
                                                                                                         defaultFont: .init(name: "Poppins-Medium", size: 25),
                                                                                                         highlightedFont: .init(name: "DarumadropOne-Regular", size: 25)),
                                                      support: Constants.support.rawValue,
                                                      fullNamePlaceholder: Constants.fullNamePlaceholder.rawValue,
                                                      emailPlaceholder: Constants.emailPlaceholder.rawValue,
                                                      passwordPlaceholder: Constants.passwordPlaceholder.rawValue,
                                                      signUpButtonTitle: Constants.signUpButtonTitle.rawValue,
                                                      additionalInfo: Constants.additionalInfo.rawValue.toAttributedString(highlighting: "sign in",
                                                                                                                           defaultFont: .init(name: "Poppins-Medium", size: 14),
                                                                                                                           highlightedFont: .init(name: "Poppins-Medium", size: 14),
                                                                                                                           link: URL(string: ""),
                                                                                                                           alignment: .center,
                                                                                                                           additionalColor: #colorLiteral(red: 0.3882352941, green: 0.8509803922, blue: 0.9529411765, alpha: 1))))
    }
}

//MARK: - Public extension

extension SignUpViewModel {
    
    //MARK: - Load constants
    
    func loadConstants() {
        prepareConstants()
    }
    
    //MARK: - Go to sign in view
    
    func goToSignInView() {
        navigateToSignInPublisher.send()
    }
    
    //MARK: - Check auth data()
    
    func checkAuthData(_ fullName: String?, _ email: String?, _ password: String?) {
        AuthService.shared.signUp(SignUpModel(fullName: fullName, email: email, password: password))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                switch error {
                case .failure(let value):
                    if let value = value as? AuthService.Errors {
                        self?.showErrorPublisher.send(value.message)
                    }
                case .finished:
                    break
                }
            } receiveValue: { value in
                
            }
            .store(in: &bindings)

    }
}
