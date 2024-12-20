//
//  FirstOpenService.swift
//  ToDoList
//
//  Created by Александр Федоткин on 20.12.2024.
//

import Foundation

final class FirstOpenService {
    
    //MARK: - Static properties
    
    static let shared = FirstOpenService()
    
    //MARK: - Private properties
    
    private let defaults = UserDefaults.standard
    
    //MARK: - Initialization
    
    private init() {}
}

//MARK: - Public extension

extension FirstOpenService {
    
    private var firstOpenKey: String {
        return "isFirstOpen"
    }
    
    func fetchState() -> Bool {
        defaults.value(forKey: firstOpenKey) as? Bool ?? true
    }
    
    func set(isFirstOpen: Bool) {
        defaults.set(isFirstOpen, forKey: firstOpenKey)
    }
}
