//
//  TabBarPages.swift
//  ToDoList
//
//  Created by Александр Федоткин on 21.12.2024.
//

import UIKit

enum TabBarPages {
    case home
    case toDoList
    case calendar
    case settings
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .toDoList
        case 2:
            self = .calendar
        case 3:
            self = .settings
        default:
            return nil
        }
    }
    
    func pageImageView() -> UIImage {
        switch self {
        case .home:
            return Images.home
        case .toDoList:
            return Images.toDoList
        case .calendar:
            return Images.calendar
        case .settings:
            return Images.settings
        }
    }
    
    func pageNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .toDoList:
            return 1
        case .calendar:
            return 2
        case .settings:
            return 3
        }
    }
}
