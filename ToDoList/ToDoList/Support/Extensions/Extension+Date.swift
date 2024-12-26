//
//  Extension+Date.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import Foundation

import Foundation

extension Date {
    func formattedForDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(self) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mma"
            timeFormatter.amSymbol = "am"
            timeFormatter.pmSymbol = "pm"
            return "Today | \(timeFormatter.string(from: self).lowercased())"
        } else if calendar.isDateInTomorrow(self) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mma"
            timeFormatter.amSymbol = "am"
            timeFormatter.pmSymbol = "pm"
            return "Tomorrow | \(timeFormatter.string(from: self).lowercased())"
        } else if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)),
                  let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek),
                  self >= startOfWeek && self <= endOfWeek {
            let dayOfWeekFormatter = DateFormatter()
            dayOfWeekFormatter.dateFormat = "EEEE | h:mma"
            dayOfWeekFormatter.amSymbol = "am"
            dayOfWeekFormatter.pmSymbol = "pm"
            return dayOfWeekFormatter.string(from: self).capitalized
        } else {
            let fullDateFormatter = DateFormatter()
            fullDateFormatter.dateFormat = "dd.MM.yy | h:mma"
            fullDateFormatter.amSymbol = "am"
            fullDateFormatter.pmSymbol = "pm"
            return fullDateFormatter.string(from: self).lowercased()
        }
    }
    
    func formattedForDisplayDateAndTime() -> (String, String) {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(self) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mma"
            timeFormatter.amSymbol = "am"
            timeFormatter.pmSymbol = "pm"
            let time = timeFormatter.string(from: self).lowercased()
            return ("Today", time)
        } else if calendar.isDateInTomorrow(self) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mma"
            timeFormatter.amSymbol = "am"
            timeFormatter.pmSymbol = "pm"
            let time = timeFormatter.string(from: self).lowercased()
            return ("Tomorrow", time)
        } else if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)),
                  let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek),
                  self >= startOfWeek && self <= endOfWeek {
            let dayOfWeekFormatter = DateFormatter()
            dayOfWeekFormatter.dateFormat = "EEEE"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mma"
            timeFormatter.amSymbol = "am"
            timeFormatter.pmSymbol = "pm"
            let day = dayOfWeekFormatter.string(from: self).capitalized
            let time = timeFormatter.string(from: self).lowercased()
            return (day, time)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yy"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mma"
            timeFormatter.amSymbol = "am"
            timeFormatter.pmSymbol = "pm"
            let date = dateFormatter.string(from: self)
            let time = timeFormatter.string(from: self).lowercased()
            return (date, time)
        }
    }
    
    func formattedForDisplayDateAndTimeInTextField() -> (String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: self)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let time = timeFormatter.string(from: self)
        
        return (date, time)
    }
}
