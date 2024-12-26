//
//  Images.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit

enum Images {
    enum NavigationImages {
        static let arrowRight = UIImage.arrowRight
        static let arrowLeft = UIImage.arrowLeft
        static let systemArrowRight = UIImage(systemName: "arrow.right")
        static let systemChevronRight = UIImage(systemName: "chevron.right")
        static let systemChevronLeft = UIImage(systemName: "chevron.left")
        static let done = UIImage.done
        static let calendar = UIImage.calendar
        static let home = UIImage.home
        static let toDoList = UIImage.toDoList
        static let settings = UIImage.settings
    }
    
    enum TextFieldImages {
        static let email = UIImage.email
        static let fullName = UIImage.fullName
        static let password = UIImage.password
        static let search = UIImage.search
        static let taskTitle = UIImage.taskTitle
        static let taskDescription = UIImage.taskDescription
        static let taskDate = UIImage.taskDate
        static let taskTime = UIImage.taskTime
    }
    
    enum SettingsImages {
        static let profile = UIImage.profile
        static let conversations = UIImage.conversation
        static let project = UIImage.projects
        static let policies = UIImage.policie
        static let logout = UIImage.logout
    }
    
    enum TaskImages {
        static let complete = UIImage.complete
        static let plus = UIImage.plus
        static let taskDetailsTitle = UIImage.taskDetailsTitle
        static let taskDetailsDateCalendar = UIImage.taskDetailsDateCalendar
        static let taskDetailsDateClock = UIImage.taskDetailDateClock
        static let taskDetailsDeleteButton = UIImage.taskDetailsDeleteButton
    }
    
    enum appImages {
        static let appLogo = UIImage.applicationLogo
    }
    
    enum OnBoardImages {
        static let firstPageImage = UIImage.firstPage
        static let secondPageImage = UIImage.secondPage
        static let thirdPageImage = UIImage.thirdPage
        static let fourthPageImage = UIImage.fourthPage
    }
}
