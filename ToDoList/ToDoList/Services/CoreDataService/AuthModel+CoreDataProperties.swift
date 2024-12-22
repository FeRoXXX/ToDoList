//
//  AuthModel+CoreDataProperties.swift
//  ToDoList
//
//  Created by Александр Федоткин on 21.12.2024.
//
//

import Foundation
import CoreData


extension AuthModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuthModel> {
        return NSFetchRequest<AuthModel>(entityName: "AuthModel")
    }

    @NSManaged public var email: String?
    @NSManaged public var fullName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var password: String?
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension AuthModel {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: UserModel)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: UserModel)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}

extension AuthModel : Identifiable {}
