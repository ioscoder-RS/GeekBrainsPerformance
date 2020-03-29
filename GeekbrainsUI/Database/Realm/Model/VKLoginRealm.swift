//
//  VKLoginRealm.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 19/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//
import RealmSwift

//MARK: текущий = последний логин
class VKLoginRealm: Object {
    @objc dynamic var id = 0
    @objc dynamic var lastName = ""
    @objc dynamic var firstName = ""
    @objc dynamic var fullName = ""
    @objc dynamic var avatarPath = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    

    func toModel() -> VKUser{
        return VKUser(lastName: lastName, firstName: firstName, avatarPath: avatarPath, photo100: "", isOnline: 0, id: id, isClosed: nil, canAccessClosed: nil, deactivated: nil)
    }
}//class VKUserRealm
