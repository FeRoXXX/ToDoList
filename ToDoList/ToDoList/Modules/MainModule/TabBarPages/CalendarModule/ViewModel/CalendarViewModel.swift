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
    
    @Published var datesOfEvents: [Date] = []
    @Published var tableViewData: [ToDoListModel] = []
    private(set) var routeToDetails: PassthroughSubject<UUID, Never> = .init()
    private var profileDataService: ProfileDataService
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Initialization
    
    init(profileDataService: ProfileDataService) {
        self.profileDataService = profileDataService
    }
}

//MARK: - Private extension

private extension CalendarViewModel {
    
    //MARK: - Bind
    
    func bind() {
        profileDataService.servicePublisher
            .receive(on: DispatchQueue.global())
            .sink { [weak self] type in
                switch type {
                case .tasksByDate(let success):
                    self?.tableViewData = success.map { ToDoListModel(taskId: $0.id,
                                                                      title: $0.title,
                                                                      date: $0.endDate.formattedForDisplay(),
                                                                      isComplete: $0.isDone) }
                case .userTasks(let success):
                    self?.datesOfEvents = success.map { $0.endDate }
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
        profileDataService.getUserTasks()
    }
    
    //MARK: - request tasks by date
    
    func requestTasks(_ date: Date) {
        profileDataService.getTaskByDate(date: date)
    }
    
    //MARK: - Navigate to detail
    
    func navigateToDetailById(_ taskId: UUID) {
        routeToDetails.send(taskId)
    }
}
