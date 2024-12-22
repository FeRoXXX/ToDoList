//
//  UserModel+CoreDataProperties.swift
//  ToDoList
//
//  Created by Александр Федоткин on 21.12.2024.
//
//

import Foundation
import CoreData


extension UserModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserModel> {
        return NSFetchRequest<UserModel>(entityName: "UserModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isDone: Bool
    @NSManaged public var endDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var noteDescription: String?
    @NSManaged public var relationship: AuthModel?

}

extension UserModel : Identifiable {}
