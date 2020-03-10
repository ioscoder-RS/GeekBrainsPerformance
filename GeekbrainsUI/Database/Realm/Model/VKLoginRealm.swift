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
    @objc dynamic var userName = ""
    @objc dynamic var avatarPath = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    

    func toModel() -> VKLogin{
        return VKLogin(id: id,
                       firstName: firstName,
                       lastName: lastName,
                       isClosed: true,
                       canAccessClosed: true,
                       city: nil,
                       avatarPath: avatarPath,
                       verified: 1)
    }
}//class VKUserRealm
