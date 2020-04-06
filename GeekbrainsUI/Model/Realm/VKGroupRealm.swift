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
    @objc dynamic var name = ""
    @objc dynamic var avatarPath = ""
    @objc dynamic var isClosed = 0
    @objc dynamic var type = ""
    @objc dynamic var userId = 0
    @objc dynamic  var compoundKey: String = "-"
    
    public override static func primaryKey() -> String? {
        return "compoundKey"
    }

    
    //создание индекса
    override class func indexedProperties() -> [String] {
        return["groupName"]
    }
    func toModel()->VKGroup{
        return VKGroup(id: id, name: name, screenName: groupName, isClosed: isClosed, type: type, isAdmin: nil, isMember: nil, isAdvertiser: nil, activity: nil, membersCount: nil, photo100: avatarPath, adminLevel: nil)
    }
}
