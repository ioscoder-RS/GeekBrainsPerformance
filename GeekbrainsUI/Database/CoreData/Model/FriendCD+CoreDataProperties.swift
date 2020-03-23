//
//  FriendCD+CoreDataProperties.swift
//  
//
//  Created by raskin-sa on 24/01/2020.
//
//

import Foundation
import CoreData


extension FriendCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendCD> {
        return NSFetchRequest<FriendCD>(entityName: "FriendCD")
    }

    @NSManaged public var id: Int64
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var avatarPath: String
    @NSManaged public var photo100: String
    @NSManaged public var deactivated: String?
    @NSManaged public var isOnline: Int16

}

extension FriendCD {
    func toCommonItem() -> VKUser {
        return VKUser(lastName: lastName, firstName: firstName, avatarPath: avatarPath, photo100: photo100, isOnline: Int(isOnline), id: Int(id), isClosed: nil, canAccessClosed: nil, deactivated: deactivated)
        }
    
}
