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
    let isDone: Bool = false
    let relationshipId: UUID?
    
    init(id: UUID = UUID(), title: String?, description: String?, endDate: Date?, relationshipId: UUID?) {
        self.id = id
        self.title = title
        self.description = description
        self.endDate = endDate
        self.relationshipId = relationshipId
    }
}
