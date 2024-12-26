//
//  CalendarViewModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 25.12.2024.
//

import Foundation
import Combine

final class CalendarViewModel {
    
    //MARK: - Private properties
    
    private(set) var pushTableData: PassthroughSubject<[ToDoListModel], Never> = .init()
    private(set) var routeToDetails: PassthroughSubject<UUID, Never> = .init()
    private var profileDataService: ProfileDataService
    private var authenticationKey: UUID
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(profileDataService: ProfileDataService, authenticationKey: UUID) {
        self.profileDataService = profileDataService
        self.authenticationKey = authenticationKey
    }
}

//MARK: - Private extension

private extension CalendarViewModel {
    
    //MARK: - Bind
    
    func bind() {
        profileDataService.servicePublisher
            .receive(on: DispatchQueue.main)
            .sink { error in
                
            } receiveValue: { [weak self] type in
                switch type {
                case .tasksByDate(let success):
                    self?.pushTableData.send(success.map { ToDoListModel(taskId: $0.id,
                                                                         title: $0.title,
                                                                         date: $0.endDate.formattedForDisplay(),
                                                                         isComplete: $0.isDone) })
                default:
                    break
                }
            }
            .store(in: &bindings)

    }
}

//MARK: - Public extension

extension CalendarViewModel {
    
    //MARK: - View loaded
    
    func viewLoaded() {
        bind()
        requestTasks(.now)
    }
    
    //MARK: - request tasks by date
    
    func requestTasks(_ date: Date) {
        profileDataService.getTaskByDate(date: date, userId: authenticationKey)
    }
    
    //MARK: - Navigate to detail
    
    func navigateToDetailById(_ taskId: UUID) {
        routeToDetails.send(taskId)
    }
}
