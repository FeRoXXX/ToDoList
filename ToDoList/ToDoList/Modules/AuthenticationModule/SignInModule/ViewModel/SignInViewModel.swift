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
    private(set) var navigateToHomePublisher: PassthroughSubject<UUID, Never> = .init()
    private(set) var showErrorPublisher: PassthroughSubject<String, Never> = .init()
    private var authService: AuthService?
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(authService: AuthService?) {
        self.authService = authService
    }
}

//MARK: - Private extension

private extension SignInViewModel {
    
    //MARK: - Prepare constants data
    
    func prepareConstants() {
        pushStaticTextPublisher
            .send(SignInStaticText(title: Constants.title.rawValue.toAttributedString(highlighting: "DO IT",
                                                                                      defaultFont: .init(name: Fonts.poppinsMedium.rawValue, size: 25),
                                                                                      highlightedFont: .init(name: Fonts.darumaDropOne.rawValue, size: 25)),
                                   support: Constants.support.rawValue,
                                   emailPlaceholder: Constants.emailPlaceholder.rawValue,
                                   passwordPlaceholder: Constants.passwordPlaceholder.rawValue,
                                   signInButtonTitle: Constants.signUpButtonTitle.rawValue,
                                   additionalInfo: Constants.additionalInfo.rawValue.toAttributedString(highlighting: "sign up",
                                                                                                        defaultFont: .init(name: Fonts.poppinsMedium.rawValue, size: 14),
                                                                                                        highlightedFont: .init(name: Fonts.poppinsMedium.rawValue, size: 14),
                                                                                                        alignment: .center,
                                                                                                        additionalColor: #colorLiteral(red: 0.3882352941, green: 0.8509803922, blue: 0.9529411765, alpha: 1))))
    }
}

//MARK: - Public extension

extension SignInViewModel {
    
    //MARK: - Load constants
    
    func loadConstants() {
        prepareConstants()
        bind()
    }
    
    //MARK: - Go to sign in view
    
    func goToSignUpView() {
        navigateToSignUpPublisher.send()
    }
    
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
    
    //MARK: - Sign in
    
    func signIn(email: String?, password: String?) {
        authService?.signIn(SignInModel(email: email, password: password))
    }
}


