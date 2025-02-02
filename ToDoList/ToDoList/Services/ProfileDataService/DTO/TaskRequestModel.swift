//
//  TaskRequestModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import Foundation

struct TaskRequestModel {
    let id: UUID
    let title: String
    let description: String
    let endDate: Date
    let isDone: Bool
    let relationshipId: UUID
}

