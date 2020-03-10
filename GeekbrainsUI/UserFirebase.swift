//
//  UserFirebase.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 04/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import FirebaseDatabase

class UserFirebase {
    var username: String?
    var age: Int?
    var city: String?
    var ref: DatabaseReference? //cсылка на текущий объект. Через нее можно удалять/изменять объект
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String: Any] else{
            return nil
        }
        
        username = dict["username"] as? String
        age = dict["age"] as? Int
        city = dict["city"] as? String
        ref = snapshot.ref
        
    }//init
    

}//class UserFirebase

     //MARK: код добавляет столбец
//     users.first?.ref?.updateChildValues(["weight":85])
     //MARK: код удаляет пользователя
     //      users.first?.ref?.removeValue()
