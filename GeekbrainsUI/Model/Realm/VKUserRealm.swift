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
    @objc dynamic var photo = ""
    @objc dynamic var deactivated: String?
    @objc dynamic var isOnline = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    //создание индекса
    override class func indexedProperties() -> [String] {
        return["lastName","deactivated"]
    }
    
    var VKUserList = List<VKUserRealm>()
    
    func toModel() -> VKUser {
        return VKUser(lastName: lastName, firstName: firstName, avatarPath: avatarPath, isOnline: isOnline, id: id)
    }
}//class VKUserRealm




