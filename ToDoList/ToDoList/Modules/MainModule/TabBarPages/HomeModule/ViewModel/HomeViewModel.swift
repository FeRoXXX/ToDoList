//
//  HomeViewModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import Foundation
import Combine

final class HomeViewModel {
    
    //MARK: - Private properties
    
    private(set) var pushTableViewData: PassthroughSubject<[[ToDoListModel]], Never> = .init()
    private(set) var pushUserProfileData: PassthroughSubject<UserPublicDataModel, Never> = .init()
    private(set) var navigateToTaskDetails: PassthroughSubject<UUID, Never> = .init()
    private var bindings: Set<AnyCancellable> = []
    private var profileDataService: ProfileDataService
    
    //MARK: - Initialization
    
    init(profileDataService: ProfileDataService) {
        self.profileDataService = profileDataService
    }
}

//MARK: - Private extension

private extension HomeViewModel {
    
    //MARK: - Bind
    
    func bind() {
        profileDataService.servicePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                switch type {
                case .userProfileData(let data):
                    self?.pushUserProfileData.send(data)
                default:
                    break
                }
            }
            .store(in: &bindings)
        
        profileDataService.servicePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                switch type {
                case .userTasks(let data):
                    let completedTasks = self?.sortTasksByDate(tasks: data.filter(\.isDone))
                    let incompleteTasks = self?.sortTasksByDate(tasks: data.filter { !$0.isDone })
                    var parsedData: [[ToDoListModel]] = []
                    
                    if let incompleteTasks,
                       !incompleteTasks.isEmpty {
                        parsedData.append(incompleteTasks)
                    }
                    
                    if let completedTasks,
                       !completedTasks.isEmpty {
                        parsedData.append(completedTasks)
                    }
                    self?.pushTableViewData.send(parsedData)
                default:
                    break
                }
            }
            .store(in: &bindings)
    }
    
    //MARK: - Sort array by current date
    
    func sortTasksByDate(tasks: [UserModel]) -> [ToDoListModel] {
        let currentDate = Date()
        
        let sortedTasks = tasks
            .sorted { task1, task2 in
                let isTask1AfterCurrent = task1.endDate >= currentDate
                let isTask2AfterCurrent = task2.endDate >= currentDate
                
                if isTask1AfterCurrent != isTask2AfterCurrent {
                    return isTask1AfterCurrent
                }
                
                return abs(task1.endDate.timeIntervalSince(currentDate)) < abs(task2.endDate.timeIntervalSince(currentDate))
            }
        
        let parsedTasks = sortedTasks.map { task in
            ToDoListModel(
                taskId: task.id,
                title: task.title,
                date: task.endDate.formattedForDisplay(),
                isComplete: task.isDone
            )
        }
        
        return Array(parsedTasks.prefix(2))
    }

}

//MARK: - Public extension

extension HomeViewModel {
    
    //MARK: - didLoad
    
    func loadData() {
        bind()
        profileDataService.getEmailAndFullName()
        profileDataService.getUserTasks()
    }
    
    //MARK: - Navigation functions
    
    func navigateToDetails(for id: UUID) {
        navigateToTaskDetails.send(id)
    }
}
