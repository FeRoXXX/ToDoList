//
//  NewTaskViewModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 24.12.2024.
//

import Foundation
import Combine

final class NewTaskViewModel {
    
    //MARK: - Private properties
    
    private var bindings: Set<AnyCancellable> = []
    private(set) var cancelNewTaskModule: PassthroughSubject<Void, Never> = .init()
    private var profileDataService: ProfileDataService
    private var authenticationKey: UUID
    
    //MARK: - Initialization
    
    init(profileDataService: ProfileDataService, authenticationKey: UUID) {
        self.profileDataService = profileDataService
        self.authenticationKey = authenticationKey
    }
}

//MARK: - Private extension

private extension NewTaskViewModel {
    
    //MARK: - Date and time formatter
    
    func combineDateAndTime(dateString: String?, timeString: String?) -> Date? {
        guard let dateString,
              let timeString else { return nil }
        let combinedFormat = "MM/yyyy HH:mm"
        
        let combinedString = "\(dateString) \(timeString)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = combinedFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.date(from: combinedString)
    }
}

//MARK: - Public extension

extension NewTaskViewModel {
    
    func createNewTask(_ task: NewTaskDataModel) {
        let endDate = combineDateAndTime(dateString: task.date, timeString: task.time)
        profileDataService.createTask(TaskModel(title: task.title, description: task.description, endDate: endDate, relationshipId: authenticationKey))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                print(error)
            } receiveValue: { [weak self] isEnd in
                self?.cancelNewTaskModule.send()
            }
            .store(in: &bindings)
    }
    
    func cancelTaskCreation() {
        cancelNewTaskModule.send()
    }
}
