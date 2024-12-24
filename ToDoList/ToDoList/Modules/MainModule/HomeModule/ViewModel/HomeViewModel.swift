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
    
    //MARK: - Bind
    
    func bind() {
        profileDataService.servicePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                print(error)
            } receiveValue: { [weak self] type in
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
            .sink { [weak self] error in
                print(error)
            } receiveValue: { [weak self] type in
                switch type {
                case .userTasks(let data):
                    let completedTasks = data.filter(\.isDone).map {ToDoListModel(taskId: $0.id,
                                                                                  title: $0.title,
                                                                                  date: $0.endDate.formattedForDisplay(),
                                                                                  isComplete: $0.isDone)}
                    let incompleteTasks = data.filter { !$0.isDone }.map { ToDoListModel(taskId: $0.id,
                                                                                         title: $0.title,
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
                default:
                    break
                }
            }
            .store(in: &bindings)
    }
}

//MARK: - Public extension

extension HomeViewModel {
    
    //MARK: - didLoad
    
    func loadData() {
        bind()
        profileDataService.getEmailAndFullName(by: userId)
        profileDataService.getUserTasksByUserId(userId)
    }
    
    func navigateToDetails(for id: UUID) {
        navigateToTaskDetails.send(id)
    }
}
