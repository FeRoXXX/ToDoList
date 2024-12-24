//
//  TaskModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import Foundation

struct TaskModel {
    let title: String?
    let description: String?
    let endDate: Date?
    let isDone: Bool = false
    let relationshipId: UUID?
}
