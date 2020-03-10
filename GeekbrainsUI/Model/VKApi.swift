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

struct CommonResponseNoCount<T: Decodable>: Decodable {
    var response: CommonResponseArrayNoCount<T>
}
struct CommonResponseArrayNoCount<T: Decodable>: Decodable{
    var items: [T]
}


class VKAPi {
    let vkURL = "https://api.vk.com/method/"
    //https://jsonplaceholder.typicode.com/users
    
//    typealias Out = Swift.Result
    
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
                }
                completion(.success(result.response.items))
            }catch{
   
                completion(.failure(error))
            }
    }
    }//func sendRequest
    
    func sendRequestNoCount<T: Decodable>(url:String, method: HTTPMethod = .get, params: Parameters,  webRequestEntity: WebRequestEntities, completion: @escaping (Out<[T],Error>)-> Void){
         
         Alamofire.request(url,method: method,parameters: params).responseData { (result) in
                                 guard let data = result.value else {return}
             
          
             do{
                     let resultJ = try JSONDecoder().decode(CommonResponseNoCount<T>.self, from: data)
        
                 //сохраняем в глобальные переменные то, что пришло из Web
                 switch webRequestEntity{
                 case .VKLogin:
                    webVKLogin = resultJ.response.items as! [VKLogin]
                 default:
                    break                 }
                completion(.success(resultJ.response.items))
             }catch{
    
                 completion(.failure(error))
             }
     }
     }//func sendRequest
    
    //Получение списка друзей
    func getFriendList(token: String,completion: @escaping (Out<[VKUser],Error>)-> Void) {
    
        let requestURL = vkURL + "friends.get"
        let params = ["v": "5.103",
                      "access_token":token,
                      "order":"name",
                      "fields":"online,city,domain,photo_50"]

        sendRequest(url: requestURL, params: params, webRequestEntity: WebRequestEntities.VKUser ) {completion($0)}
                            
    }//func getFriendList
    
    //получение залогиненного пользователя
    func getLogin(token: String, loginId: String, completion: @escaping (Out<[VKLogin],Error>)-> Void) {
    
        let requestURL = vkURL + "users.get"
        let params = ["v": "5.103",
                      "access_token":token,
                      "order":"name",
                      "fields":"photo_50,city,verified"]

        sendRequestNoCount(url: requestURL, params: params, webRequestEntity: WebRequestEntities.VKLogin ) {completion($0)}
                            
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
    
    
        // MARK: Список новостей
        // Отдельный API-request для новостей, наш sendRequest() не подходит по CommonResponse
        // Структура новостей отличается от трех остальных сущностей (поэтому CommonResponseNews)
        // Так же у нас возвращается не массив а объект, у которого нет items
        
//    func getNewsfeed(token: String, userID: String, completion: @escaping (Out<VKNews, Error>) -> Void) {
//            let url = vkURL + "newsfeed.get"
//            let parameters = ["access_token"    : token,
//                              "owner_id"        : userID,
//                              "v"               : "5.103",
//                              "filters"         : "post",
//                              "return_banned"   : "0",
//                              "count"           : "20"]
//
//        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
//            guard let data = response.value else {return}
//
//
//                    do {
//                        let newsResponse = try JSONDecoder().decode(CommonResponseNews.self, from: data as! Data )
//                        completion(.success(newsResponse.response1))
//                    } catch {
//                        completion(.failure(error))
//                    }
//
//                }//completion of Alamofire.request
//        }//func getNewsfeed
    
    func getNewsList(token: String, userId:String, from: String?, version: String, completion: @escaping (Swift.Result<ResponseNews, Error>) -> Void ) {
         let requestURL = vkURL + "newsfeed.get"
         var params: [String : String]
         if let myFrom = from {
             params = ["access_token": token,
                           "user_id": userId,
                           "source_ids": "friends,groups,pages,following",
                           "filters": "post, note",
                           "count": "20",
                 //          "fields": "first_name,last_name,name,photo_100,online",
                           "start_from": myFrom,
                           "v": version]
             
         } else {
             params = ["access_token": token,
                           "user_id": userId,
                           "source_ids": "friends,groups,pages, following",
                           "filters": "post, note",
                           "count": "20",
            //               "fields": "first_name,last_name,name,photo_100,online",
                           "v": version]
         }
         //Делаем остановку на дозагрузку, как в нативном VK-клиенте. Защита при одновременном срабатывании методов дозагрузки и обновления.
         Alamofire.SessionManager.default.session.getAllTasks { tasks in tasks.forEach{ $0.cancel()} }
         
         Alamofire.request(requestURL,
                           method: .get,
                           parameters: params as Parameters)
             .responseData { (result) in
                 guard let data = result.value else { return }
                 do {
                  //  print(String(decoding: data, as: UTF8.self))
                    let result = try JSONDecoder().decode(CommonResponseNews.self, from: data)
                     completion(.success(result.response))
                 } catch {
                     
//                     //Пример обработки определенной ошибки (5: токен привязан к другому IP адресу)
//                     do {
//                         let result = try JSONDecoder().decode(ResponseErrorVK.self, from: data)
//                         if result.error.errorCode == 5 {
//                             let keychain = Keychain(service: "UserSecrets")
//                             keychain["token"] = nil
//                             keychain["userId"] = nil
//                             print("[Logging] Your data is cleared, please restart the application")
//                         }
//                         completion(.failure(error))
//                     } catch {
//                         completion(.failure(error))
//                     }
                     completion(.failure(error))
                 }
         }
     }
    
}//class VKAPi


