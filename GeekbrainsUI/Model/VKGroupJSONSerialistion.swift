//
//  VKGroupJSONSerialistion.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 19/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

//
//РЕАЛИЗАЦИЯ вэб-запроса не через протокол Codable а через JSONSerialization
//

import Alamofire

  let vkURLJSON = "https://api.vk.com/method/"

struct VKGroupJSON: Codable {
let id: Int
    let name: String

    init (json: [String:Any]){
        self.id = json["id"] as! Int
        self.name = json["name"] as! String
        }
}

//Получение групп текущего пользователя
  func getGroupsListJSON(token: String, userId: String){
      let requestURL = vkURLJSON + "groups.get"
      let params = ["v": "5.103",
                    "access_token":token,
                    "user_id":userId,
                    "extended":"1"
      ]
      
      
      Alamofire.request(requestURL,
                        method: .post,
                        parameters: params).responseData { (response) in
                          
                            guard response.value != nil else{
                              return
                          }
                          
     
                          
                            _ = String(bytes: response.data!, encoding: .utf8)
                           let jsonObject = try? JSONSerialization.jsonObject(with: response.value!, options: .mutableContainers)
                           
                           let json = jsonObject as! [String: Any]
                           let response = json["response"] as! [String: Any]
                           var results = [VKGroupJSON]()
                           
                           for value in response["items"] as! [Any]{
                           let group = value as! [String: Any]
                           results.append(VKGroupJSON(json: group))
                           }
                           print ("Получение групп по текущему запросу пользователя и парсинг")
                           
                           print(results)
                          
      }
  }//func getGroupsList
