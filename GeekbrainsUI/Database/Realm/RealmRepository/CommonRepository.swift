//
//  CommonRepository.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 29/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//


import RealmSwift

class CommonRepository {
    
    func getAllfromTable<T: Object> (vkObject: VKObjects) throws -> Results<T>{
        var object:Object.Type
        
        let realm = try Realm()
        switch vkObject{
        case .VKGroup:
            object = VKGroupRealm.self
        case .VKPhoto:
            object = VKPhotosRealm.self
        case .VKUser:
            object = VKUserRealm.self
        case .VKLogin:
            object = VKLoginRealm.self
        }//switch
        //   tmpdefault = realm.objects(object.self).filter("FALSEPREDICATE")
        //MARK: падает при повторном вызове после search
        return realm.objects(object.self) as! Results<T>
    }//func getAllfromTable
    
    // MARK: - Deletion
    func deleteVKObject(object: VKObjects){
        let realm = try! Realm()
        
        switch object{
        case .VKUser:
            try! realm.write {
                return realm.delete(realm.objects(VKUserRealm.self))
            }
        case .VKGroup:
            try! realm.write {
                return realm.delete(realm.objects(VKGroupRealm.self))
            }
        case .VKPhoto:
            try! realm.write {
                realm.delete(realm.objects(VKPhotosRealm.self))
            }
        case .VKLogin:
            try! realm.write {
                realm.delete(realm.objects(VKLoginRealm.self))
            }
        }//switch object
        
    }//deleteVKObject(object: VKObjects)
    
    func deleteAllRealmTables () {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
    }
} //class CommonRepository

