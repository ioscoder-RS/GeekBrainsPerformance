//
//  VKApi.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 15/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import WebKit
import Alamofire

enum RequestError: Error {
    case failedRequest(message: String)
    case decodableError
}

enum WebRequestEntities{
    case VKUser
    case VKGroup
    case VKPhoto
    case VKLogin
}


struct CommonResponse<T: Decodable>: Decodable {
    var response: CommonResponseArray<T>
}

struct CommonResponseArray<T: Decodable>: Decodable{
    var count: Int
    var items: [T]
}

class VKAPi {
    let vkURL = "https://api.vk.com/method/"
    //https://jsonplaceholder.typicode.com/users
        
    func sendRequest<T: Decodable>(url:String, method: HTTPMethod = .get, params: Parameters,  webRequestEntity: WebRequestEntities, completion: @escaping (Out<[T],Error>)-> Void){
        
        Alamofire.request(url,method: method,parameters: params).responseData { (result) in
            guard let data = result.value else {return}
            
            do{
                let result = try JSONDecoder().decode(CommonResponse<T>.self, from: data)
                
                //сохраняем в глобальные переменные то, что пришло из Web
                switch webRequestEntity{
                case .VKUser:
                    webVKUsers = result.response.items as! [VKUser]
                case .VKGroup:
                    webVKGroups = result.response.items as! [VKGroup]
                case .VKPhoto:
                    webVKPhotos = result.response.items as! [VKPhoto]
                default:
                    break
                }//switch
                completion(.success(result.response.items))
            }catch{
                
                completion(.failure(error))
            }//do-catch
        }//Alamofire.request completion
    }//func sendRequest
    
    //Получение списка друзей
    func getFriendList(token: String,completion: @escaping (Out<[VKUser],Error>)-> Void) {
    
        let requestURL = vkURL + "friends.get"
        let params = ["v": "5.103",
                      "access_token":token,
                      "order":"name",
                      "fields":"online,city,domain,photo_50, photo_100, id, deactivated"]

        sendRequest(url: requestURL, params: params, webRequestEntity: WebRequestEntities.VKUser ) {completion($0)}
                            
    }//func getFriendList
    
    //Получение фотографий человека
    func getPhotosList(token: String, userId: Int, completion: @escaping (Out<[VKPhoto], Error>)-> Void) {
        let requestURL = vkURL + "photos.get"
        let params = ["v": "5.103",
                      "access_token":token,
                      "owner_id":String(userId),
                      "extended":"1",
                      "album_id":"wall"
        ]
        
       sendRequest(url: requestURL, params: params, webRequestEntity: WebRequestEntities.VKPhoto) {completion($0)}
    }//func getPhotosList
    
    //Получение групп текущего пользователя
    func getGroupsList(token: String, userId: String, completion: @escaping (Out<[VKGroup], Error>)-> Void) {
        let requestURL = vkURL + "groups.get"
        let params = ["v": "5.103",
                      "access_token":token,
                      "user_id":userId,
                      "extended":"1"
        ]
        
        sendRequest(url: requestURL, params: params, webRequestEntity: WebRequestEntities.VKGroup) {completion($0)}
    }//func getGroupsList
    
    //Получение групп по поисковому запросу;
//    func searchGroups (token: String, query: String, completion: () -> ()){
//        let requestURL = vkURL + "groups.search"
//        let params = ["v": "5.103",
//                      "access_token":token,
//                      "q":query,
//                      "type":"group",
//                      "count":"3",
//                      "country_id":"1" //Россия
//        ]
//
//        Alamofire.request(requestURL,
//                          method: .post,
//                          parameters: params).responseJSON(completionHandler: { (response) in
//                            (print("\nПолучение групп по поисковому запросу \(query)"),print(response.value!))
//                          })
//    }//func searchGroups
    
    

    
    func getNewsList(token: String, userId:String, nextFrom: String?, startTime: String?, version: String, completion: @escaping (Out<(ResponseNews), Error>) -> Void ) {
         let requestURL = vkURL + "newsfeed.get"
         var params: [String : String]
    
             params = ["access_token": token,
                           "user_id": userId,
                           "source_ids": "friends,groups",
                           "filters": "post, note",
                           "count": "25",
                           "start_from": nextFrom ?? "",
                           "start_time": startTime ?? "",
                           "v": version]
             
         Alamofire.request(requestURL,
                           method: .get,
                           parameters: params as Parameters)
             .responseData { (result) in
                 guard let data = result.value else { return }
                 do {
                // не стирать! это для отладки - посмотреть содержимое запроса
 //                  print(String(decoding: data, as: UTF8.self))

                    let result = try JSONDecoder().decode(CommonResponseNews.self, from: data)
                     completion(.success(result.response))
                    
                 } catch {
                     print(String(decoding: data, as: UTF8.self))
                     completion(.failure(error))
                 }
         }
     }//func getNewsList
    
    //получение залогиненного пользователя
    func getLogin(token: String, loginId: String, completion: @escaping (Out<[VKUser],Error>)-> Void) {
        
        let requestURL = vkURL + "users.get"
        let params = ["v": "5.103",
                      "access_token":token,
                      "order":"name",
                      "fields":"photo_50,photo_100,city,verified, online"]
        
        Alamofire.request(requestURL,method: .get,parameters: params).responseData { (result) in
            guard let data = result.value else {return}
            
 //           print(String(decoding: data, as: UTF8.self))
            do{
                let resultJ = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                completion(.success(resultJ.response))
            }catch{
                
                completion(.failure(error))
            }
            
        }
    }//func getLogin
}//class VKAPi


