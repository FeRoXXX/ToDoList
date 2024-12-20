//
//  AuthModel+CoreDataProperties.swift
//  ToDoList
//
//  Created by Александр Федоткин on 20.12.2024.
//
//

import Foundation
import CoreData


extension AuthModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuthModel> {
        return NSFetchRequest<AuthModel>(entityName: "AuthModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var fullName: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?

}

extension AuthModel : Identifiable {

}
