//
//  TaskModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import Foundation

struct TaskModel {
    let id: UUID
    let title: String?
    let description: String?
    let endDate: Date?
    var isDone: Bool = false
    
    init(id: UUID = UUID(), title: String?, description: String?, endDate: Date?, isDone: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.endDate = endDate
        self.isDone = isDone
    }
}
