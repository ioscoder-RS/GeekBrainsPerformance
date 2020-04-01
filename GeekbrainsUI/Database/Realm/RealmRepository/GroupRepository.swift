//
//  GroupRepository.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 29/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import RealmSwift

protocol GroupsSource{
    func getAllGroups(userId: Int) throws -> Results<VKGroupRealm>
    func addGroups (groups:[VKGroup])
    func searchGroups(name: String) throws -> Results<VKGroupRealm>
}

class GroupRepository: GroupsSource {
    
    var localCommonRepository = CommonRepository()
    
    func getAllGroups(userId: Int) throws -> Results<VKGroupRealm>{
        var filter: String
        
        let realm = try Realm()
        do {
            filter = "userId == %@"
            return try realm.objects(VKGroupRealm.self).filter(filter, userId) as Results <VKGroupRealm>
            //    return try localCommonRepository.getAllfromTable(vkObject: .VKGroup) as Results<VKGroupRealm>
        } catch {
            throw error
        }
    }//func getAllUsers
    
    func addGroups (groups:[VKGroup]) {
        do {
            let realm = try Realm()
            try realm.write {
                var groupsToAdd = [VKGroupRealm]()
                groups.forEach{
                    group in
                    let groupRealm = VKGroupRealm()
                    groupRealm.id = group.id
                    groupRealm.name = group.name
                    groupRealm.groupName = group.screenName
                    groupRealm.avatarPath = group.photo100
                    groupRealm.isClosed = group.isClosed
                    groupRealm.type = group.type
                    groupRealm.userId = Int(Session.shared.userId)!
                    groupRealm.compoundKey = String(group.id)+"-"+Session.shared.userId
                    groupsToAdd.append(groupRealm)
                }//groups.forEach
                realm.add(groupsToAdd, update: .modified)
            }//realm.write
      //      print(realm.objects(VKGroupRealm.self))
        }catch{
            print(error)
        }
    }// func addGroups
    
    func searchGroups(name: String) throws -> Results<VKGroupRealm> {
        do {
            let realm = try Realm()
            return realm.objects(VKGroupRealm.self).filter("groupName CONTAINS[c] %@", name)
        } catch{
            throw error
        }
    }//func searchUsers
}//class class GroupRepository
