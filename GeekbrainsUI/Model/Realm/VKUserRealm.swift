//
//  VKUserRealm.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 22/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import RealmSwift

class VKUserRealm: Object {
    @objc dynamic var id = 0
    @objc dynamic var lastName = ""
    @objc dynamic var firstName = ""
    @objc dynamic var userName = ""
    @objc dynamic var avatarPath = ""
    @objc dynamic var photo100 = ""
    @objc dynamic var deactivated: String?
    @objc dynamic var isOnline = 0
    @objc dynamic var userId = 0
    @objc dynamic var compoundKey: String = "-"
 
    
    public override static func primaryKey() -> String? {
        return "compoundKey"
    }

    
    //создание индекса
    override class func indexedProperties() -> [String] {
        return["lastName","deactivated"]
    }
    
    var VKUserList = List<VKUserRealm>()
    
    func toModel() -> VKUser {
        return VKUser(lastName: lastName, firstName: firstName, avatarPath: avatarPath, photo100: photo100, isOnline: isOnline, id: id, isClosed: nil, canAccessClosed: nil, deactivated: deactivated)
    }
}//class VKUserRealm




