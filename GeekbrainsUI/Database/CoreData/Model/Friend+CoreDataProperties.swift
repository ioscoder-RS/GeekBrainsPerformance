//
//  Friend+CoreDataProperties.swift
//  
//
//  Created by raskin-sa on 24/01/2020.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var id: Int64
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var avatarPath: String?
    @NSManaged public var deactivated: String?
    @NSManaged public var isOnline: Int16

}
