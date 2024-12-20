//
//  OnBoardingMainViewModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 19.12.2024.
//

import Foundation
import Combine

final class OnBoardingMainViewModel {
    
    enum Constants: String {
        case firstPageImage
        case firstPageDescription = "Plan your tasks to do, that way you’ll stay organized and you won’t skip any"
        case secondPageImage
        case secondPageDescription = "Make a full schedule for the whole week and stay organized and productive all days"
        case thirdPageImage
        case thirdPageDescription = "create a team task, invite people and manage your work together"
        case fourthPageImage
        case fourthPageDescription = "You informations are secure with us"
    }
    
    //MARK: - Private properties
    
    private var currentIndex: Int = 0
    private var totalPages: Int
    private var staticData: [OnBoardingStaticElements] = []
    private(set) var currentPagePublisher: PassthroughSubject<Int, Never> = .init()
    private(set) var staticDataPublisher: PassthroughSubject<[OnBoardingStaticElements], Never> = .init()
    private(set) var changeImage: PassthroughSubject<String, Never> = .init()
    private(set) var routeToAuthentication: PassthroughSubject<Void, Never> = .init()
    
    //MARK: - Public properties
    
    //MARK: - Initialization
    
    init(totalPages: Int) {
        self.totalPages = totalPages
    }
}

//MARK: - Public extension

extension OnBoardingMainViewModel {
    
    //MARK: - Initialize static data
    
    func initializeStaticData() {
        staticData = [
            OnBoardingStaticElements(imageName: Constants.firstPageImage.rawValue, description: Constants.firstPageDescription.rawValue),
            OnBoardingStaticElements(imageName: Constants.secondPageImage.rawValue, description: Constants.secondPageDescription.rawValue),
            OnBoardingStaticElements(imageName: Constants.thirdPageImage.rawValue, description: Constants.thirdPageDescription.rawValue),
            OnBoardingStaticElements(imageName: Constants.fourthPageImage.rawValue, description: Constants.fourthPageDescription.rawValue),
        ]
        staticDataPublisher.send(staticData)
    }
    
    //MARK: - Calculate page
    
    func calculatePage() {
        guard totalPages > currentIndex + 1 else {
            routeToAuthentication.send()
            return
        }
        currentIndex += 1
        currentPagePublisher.send(currentIndex)
        if currentIndex == totalPages - 1 {
            changeImage.send("done")
        } else {
            changeImage.send("arrow.right")
        }
    }
    
    //MARK: - Update page
    
    func updatePage(index: Int) {
        guard totalPages > index else { return }
        currentIndex = index
        if currentIndex == totalPages - 1 {
            changeImage.send("done")
        } else {
            changeImage.send("arrow.right")
        }
    }
}
