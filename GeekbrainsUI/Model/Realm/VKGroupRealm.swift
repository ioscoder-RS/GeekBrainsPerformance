//
//  VKGroupRealm.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 22/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import RealmSwift

class VKGroupRealm: Object {
    @objc dynamic var id = 0
    @objc dynamic var groupName = ""
    @objc dynamic var avatarPath = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    //создание индекса
    override class func indexedProperties() -> [String] {
        return["groupName"]
    }
    func toModel()->VKGroup{
        return VKGroup(id: id, groupName: groupName, avatarPath: avatarPath)
    }
}
