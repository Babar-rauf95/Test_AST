//
//  UserSession+CoreDataProperties.swift
//  
//
//  Created by User on 16/03/2025.
//
//

import Foundation
import CoreData


extension UserSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserSession> {
        return NSFetchRequest<UserSession>(entityName: "UserSession")
    }

    @NSManaged public var userID: String?
    @NSManaged public var email: String?
    @NSManaged public var role: String?
    @NSManaged public var timestamp: Date?

}
