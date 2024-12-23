//
//  UserDefaultsService.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import Foundation

final class UserDefaultsService {
    
    //MARK: - Private properties
    
    private let defaults = UserDefaults.standard
    
    //MARK: - Initialization
    
    init() {}
}

//MARK: - Public extension

extension UserDefaultsService {
    
    private var firstOpenKey: String {
        return "isFirstOpen"
    }
    
    private var alreadyAuthorizationKey: String {
        return "alreadyAuthorized"
    }
    
    func fetchState() -> Bool {
        defaults.value(forKey: firstOpenKey) as? Bool ?? true
    }
    
    func set(isFirstOpen: Bool) {
        defaults.set(isFirstOpen, forKey: firstOpenKey)
    }
    
    func fetchAuthorizationState() -> UUID? {
        guard let value = defaults.value(forKey: alreadyAuthorizationKey) as? String,
              let id = UUID(uuidString: value) else {
            return nil
        }
        return id
    }
    
    func set(_ uuid: UUID) {
        defaults.set(uuid.uuidString, forKey: alreadyAuthorizationKey)
    }
    
    func deleteAuthorizationState() {
        defaults.removeObject(forKey: alreadyAuthorizationKey)
    }
}
