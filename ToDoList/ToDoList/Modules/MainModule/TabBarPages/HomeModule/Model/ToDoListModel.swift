//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import Foundation

struct ToDoListModel: Equatable {
    let taskId: UUID
    let title: String
    let date: String
    let isComplete: Bool
}
