//
//  LoginRepository.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 19/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import RealmSwift

protocol LoginSource{
    func getLogin() -> VKLogin?
    func addLogin(login:VKLogin)
    func clearLogin()
}

class LoginRepository: LoginSource {
    
    var localCommonRepository = CommonRepository()
    
    
    //MARK: возвращает текущий login
    //в таблице всегда одна запись или ничего
    func getLogin() -> VKLogin? {
        
        var loginRealm: VKLoginRealm?
        var login : VKLogin?
        
        let realm = try! Realm()
        
        loginRealm = realm.objects(VKLoginRealm.self).first
        
        if loginRealm != nil {
            login = loginRealm?.toModel()
            return login
        }
        else{
            return nil
        }
        
    }
    
    func addLogin(login: VKLogin) {
       
        //вставляем запись о логине только в пустую таблицу
        //если таблица не пустая - неважно почему - не вставляем, это - ошибка
        if getLogin() != nil {return}
        
        do {
            let realm = try Realm()
            try realm.write {
                    let loginRealm = VKLoginRealm()
                    loginRealm.id = login.id
                    loginRealm.firstName = login.firstName
                    loginRealm.lastName = login.lastName
                    loginRealm.userName = String(login.firstName + " " + login.lastName)
                    loginRealm.avatarPath = login.avatarPath
                realm.add(loginRealm, update: .modified)
            }
     //       print(realm.objects(VKUserRealm.self))
        }catch{
            print(error)
        }
    }//func addLogin
    
    func clearLogin() {
        return localCommonRepository.deleteVKObject(object: .VKLogin)
    }
    

}//class UserRepository
