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
    
    private var firstOpenKey: String {
        return "isFirstOpen"
    }
    
    private var alreadyAuthorizationKey: String {
        return "alreadyAuthorized"
    }
    
    //MARK: - Initialization
    
    init() {}
}

//MARK: - Public extension

extension UserDefaultsService {
    
    //MARK: - Fetch firstOpen state
    
    func fetchState() -> Bool {
        defaults.value(forKey: firstOpenKey) as? Bool ?? true
    }
    
    //MARK: - Set firstOpen state
    
    func set(isFirstOpen: Bool) {
        defaults.set(isFirstOpen, forKey: firstOpenKey)
    }
    
    //MARK: - Fetch authorization state
    
    func fetchAuthorizationState() -> UUID? {
        guard let value = defaults.value(forKey: alreadyAuthorizationKey) as? String,
              let id = UUID(uuidString: value) else {
            return nil
        }
        return id
    }
    
    //MARK: - Set authorization state
    
    func set(_ uuid: UUID) {
        defaults.set(uuid.uuidString, forKey: alreadyAuthorizationKey)
    }
    
    //MARK: - Delete authorization state
    
    func deleteAuthorizationState() {
        defaults.removeObject(forKey: alreadyAuthorizationKey)
    }
}
