//
//  UserCD+CoreDataProperties.swift
//  
//
//  Created by raskin-sa on 21/01/2020.
//
//

import Foundation
import CoreData


extension UserCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCD> {
        return NSFetchRequest<UserCD>(entityName: "UserCD")
    }

    @NSManaged public var id: Int64
    @NSManaged public var photo: String?
    @NSManaged public var name: String?

}
