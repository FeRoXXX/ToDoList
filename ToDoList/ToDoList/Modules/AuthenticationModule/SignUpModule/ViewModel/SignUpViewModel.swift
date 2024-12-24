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
    private(set) var navigateToHomePublisher: PassthroughSubject<UUID, Never> = .init()
    private(set) var showErrorPublisher: PassthroughSubject<String, Never> = .init()
    private let authService: AuthService?
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(authService: AuthService?) {
        self.authService = authService
    }
}

//MARK: - Private extension

private extension SignUpViewModel {
    
    //MARK: - Prepare constants data
    
    func prepareConstants() {
        pushStaticTextPublisher.send(SignUpStaticText(title: Constants.title.rawValue.toAttributedString(highlighting: "DO IT",
                                                                                                         defaultFont: .init(name: Fonts.poppinsMedium.rawValue, size: 25),
                                                                                                         highlightedFont: .init(name: Fonts.darumaDropOne.rawValue, size: 25)),
                                                      support: Constants.support.rawValue,
                                                      fullNamePlaceholder: Constants.fullNamePlaceholder.rawValue,
                                                      emailPlaceholder: Constants.emailPlaceholder.rawValue,
                                                      passwordPlaceholder: Constants.passwordPlaceholder.rawValue,
                                                      signUpButtonTitle: Constants.signUpButtonTitle.rawValue,
                                                      additionalInfo: Constants.additionalInfo.rawValue.toAttributedString(highlighting: "sign in",
                                                                                                                           defaultFont: .init(name: Fonts.poppinsMedium.rawValue, size: 14),
                                                                                                                           highlightedFont: .init(name: Fonts.poppinsMedium.rawValue, size: 14),
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
        bind()
    }
    
    //MARK: - Go to sign in view
    
    func goToSignInView() {
        navigateToSignInPublisher.send()
    }
    
    //MARK: - Bind
    
    func bind() {
        authService?.servicePublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] types in
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
    
    //MARK: - Sign up
    
    func signUp(fullName: String?, email: String?, password: String?) {
        authService?.signUp(SignUpModel(fullName: fullName, email: email, password: password))
    }
}
