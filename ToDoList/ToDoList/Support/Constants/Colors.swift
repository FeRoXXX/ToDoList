//
//  Colors.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit

enum Colors {
    enum Background {
        static let appBackgroundTop = UIColor(red: 18/255, green: 83/255, blue: 170/255, alpha: 1).cgColor
        static let appBackgroundBottom = UIColor(red: 5/255, green: 36/255, blue: 62/255, alpha: 1).cgColor
        static let calendarBackgroundTop = UIColor.white.withAlphaComponent(0.4).cgColor
        static let calendarBackgroundBottom = UIColor.white.withAlphaComponent(0.1).cgColor
    }
    static let blackColorFirst = UIColor.black
    static let blackColorSecond = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
    static let blackColorThird = UIColor(red: 0, green: 0, blue: 0, alpha: 0.44)
    static let whiteColorFirst = UIColor.white
    static let whiteColorSecond = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
    static let whiteColorThird = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
    static let whiteColorFourth = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    static let lightBlueFirst = UIColor(red: 134/255, green: 218/255, blue: 237/255, alpha: 1)
    static let lightBlueSecond = UIColor(red: 99/255, green: 217/255, blue: 243/255, alpha: 1)
    static let lightBlueThird = UIColor(red: 14/255, green: 165/255, blue: 233/255, alpha: 1)
    static let lightBlueFourth = UIColor(red: 23/255, green: 161/255, blue: 250/255, alpha: 1)
    static let lightBlueFifth = UIColor(red: 82/255, green: 181/255, blue: 245/255, alpha: 1)
    static let darkBlue = UIColor(red: 5/255, green: 36/255, blue: 62/255, alpha: 1)
    static let darkBlueSecond = UIColor(red: 16/255, green: 45/255, blue: 83/255, alpha: 0.8)
    static let clearColor = UIColor.clear
    static let redColor = UIColor(red: 220/255, green: 67/255, blue: 67/255, alpha: 1)
}
