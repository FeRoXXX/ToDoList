//
//  SettingsViewModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 25.12.2024.
//

import Foundation
import Combine

final class SettingsViewModel {
    
    //MARK: - Private properties
    
    private let authenticationKey: UUID
    private let profileDataService: ProfileDataService
    private(set) var routeToAuthentication: PassthroughSubject<Void, Never> = .init()
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(profileDataService: ProfileDataService, authenticationKey: UUID) {
        self.profileDataService = profileDataService
        self.authenticationKey = authenticationKey
    }
}

//MARK: - Private extension

private extension SettingsViewModel {
    
    //MARK: - Bind
    
    func bind() {
        profileDataService.servicePublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] types in
                switch types {
                case .logoutResult:
                    self?.routeToAuthentication.send()
                default:
                    break
                }
            }
            .store(in: &bindings)
    }
}

//MARK: - Public extension

extension SettingsViewModel {
    
    //MARK: - Load data function
    
    func loadData() {
        bind()
    }
    
    //MARK: - binding function
    
    func logout() {
        profileDataService.logout(user: authenticationKey)
    }
}

