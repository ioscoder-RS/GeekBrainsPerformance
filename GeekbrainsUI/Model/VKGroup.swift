//
//  VKGroup.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 19/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//



// MARK: - Group
struct VKGroup: Codable {
    let id: Int
    let groupName:String
    let avatarPath:String
    //    let screenName: String
    //    let isClosed: Int
    //    let type: String
    //    let isAdmin, isMember, isAdvertiser: Int
    //
    //    let photo100, photo200: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupName = "name"
        case avatarPath = "photo_50"
        //        case screenName = "screen_name"
        //        case isClosed = "is_closed"
        //        case type
        //        case isAdmin = "is_admin"
        //        case isMember = "is_member"
        //        case isAdvertiser = "is_advertiser"
        //
        //        case photo100 = "photo_100"
        //        case photo200 = "photo_200"
    }
}//struct VKGroup:

struct GroupResponse: Codable {
    let response: GroupResponseData
}

// MARK: - Response
struct GroupResponseData: Codable {
    let count: Int
    let items: [VKGroup]
}

var webVKGroups = [VKGroup]()

//extension GroupResponse{
//         func getGroups(groups: [VKGroup]) -> [Group]{
//            //Функция имеет два назначения:
//            //1. Сохранить данные пришедшие из Web в экземпляре структуры
//            //2. Преобразовать модель данных из web-запроса в нужную нам модель для отображения, если они различаются
//            var myGroups = [Group]()
//
//            for a in 0...groups.count-1 {
//                myGroups.append(Group(id:groups[a].id, groupName:groups[a].groupName, avatarPath:groups[a].avatarPath ))
//            }
//            return myGroups
//        }
//}
         func convertGroups(groups: [VKGroup]) -> [Group]{
            //Функция имеет два назначения:
            //1. Сохранить данные пришедшие из Web в экземпляре структуры
            //2. Преобразовать модель данных из web-запроса в нужную нам модель для отображения, если они различаются
            var myGroups = [Group]()

            for a in 0...groups.count-1 {
                myGroups.append(Group(id:groups[a].id, groupName:groups[a].groupName, avatarPath:groups[a].avatarPath ))
            }
            return myGroups
        }

