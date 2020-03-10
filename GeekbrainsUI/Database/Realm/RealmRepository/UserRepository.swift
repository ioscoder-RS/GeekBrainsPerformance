//
//  RealmRepository.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 28/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import RealmSwift

protocol FriendsSource{
    func getAllUsers() throws -> Results<VKUserRealm>
    func getUser(id:Int, lastName: String?, avatarPath: String?) -> VKUserRealm?
    func addUsers(users:[VKUser])
    func searchUsers(name: String) throws -> Results<VKUserRealm>
}

class UserRepository: FriendsSource {
    
    var localCommonRepository = CommonRepository()
    
    func getAllUsers() throws -> Results<VKUserRealm>{
        let realm = try Realm()
        do {
            //  return try localCommonRepository.getAllfromTable(vkObject: .VKUser) as Results<VKUserRealm>
            return try realm.objects(VKUserRealm.self) as Results <VKUserRealm>
        } catch {
            throw error
        }
    }//func getAllUsers
    
    //MARK: Поиск пользователя по параметру на выбор
    func getUser(id:Int, lastName: String?, avatarPath: String?) -> VKUserRealm? {
        
        var filter: String
        let realm = try! Realm()
        
        if id != 0 {
            filter = "id == %@"
            return realm.objects(VKUserRealm.self).filter(filter, id).first
        } else
        {
            guard let localavatarPath = avatarPath else {return nil}
            filter = "avatarPath == %@"
            return realm.objects(VKUserRealm.self).filter(filter, localavatarPath).first
        }
    }
    
    func addUsers(users:[VKUser]){
        do {
            let realm = try Realm()
            try realm.write {
                var usersToAdd = [VKUserRealm]()
                users.forEach { user in
                    let userRealm = VKUserRealm()
                    userRealm.id = user.id
                    userRealm.firstName = user.firstName
                    userRealm.lastName = user.lastName
                    userRealm.userName = String(user.firstName + " " + user.lastName)
                    userRealm.avatarPath = user.avatarPath
                    usersToAdd.append(userRealm)
                }
                realm.add(usersToAdd, update: .modified)
            }
     //       print(realm.objects(VKUserRealm.self))
        }catch{
            print(error)
        }
    }//func addUsers
    
    func searchUsers(name: String) throws -> Results<VKUserRealm> {
        do {
            let realm = try Realm()
            return realm.objects(VKUserRealm.self).filter("userName CONTAINS[c] %@", name)
        } catch{
            throw error
        }
    }//func searchUsers

}//class UserRepository
