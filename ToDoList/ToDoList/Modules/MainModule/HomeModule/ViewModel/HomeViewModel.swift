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
    private var bindings: Set<AnyCancellable> = []
    private var userId: UUID
    private var profileDataService: ProfileDataService
    
    //MARK: - Initialization
    
    init(userId: UUID, profileDataService: ProfileDataService) {
        self.userId = userId
        self.profileDataService = profileDataService
    }
}

//MARK: - Private extension

private extension HomeViewModel {
    
}

//MARK: - Public extension

extension HomeViewModel {
    
    //MARK: - didLoad
    
    func loadData() {
        getUserProfileData()
        requestTableViewData()
    }
    
    //MARK: - Get user profile data
    
    func getUserProfileData() {
        profileDataService.getEmailAndFullName(by: userId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                print(error)
            } receiveValue: { [weak self] data in
                self?.pushUserProfileData.send(data)
            }
            .store(in: &bindings)
    }
    
    //MARK: - Request Table view data
    
    func requestTableViewData() {
        profileDataService.getUserTasksByUserId(userId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                print(error)
            } receiveValue: { [weak self] data in
                let completedTasks = data.filter(\.isDone).map {ToDoListModel(title: $0.title,
                                                                              date: $0.endDate.formattedForDisplay(),
                                                                              isComplete: $0.isDone)}
                let incompleteTasks = data.filter { !$0.isDone }.map { ToDoListModel(title: $0.title,
                                                                                     date: $0.endDate.formattedForDisplay(),
                                                                                     isComplete: $0.isDone)}
                var parsedData: [[ToDoListModel]] = []
                if !completedTasks.isEmpty {
                    parsedData.append(completedTasks)
                }
                
                if !incompleteTasks.isEmpty {
                    parsedData.append(incompleteTasks)
                }
                self?.pushTableViewData.send(parsedData)
            }
            .store(in: &bindings)

    }
}
