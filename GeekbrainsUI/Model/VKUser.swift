//
//  VKUser.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 19/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//



// MARK: - Response
struct VKUser: Codable {
    var lastName:String
    var firstName:String
    var fullName: String { return firstName + " " + lastName }
    var avatarPath:String
    let photo100: String
    var isOnline:Int
    var id:Int
    let isClosed, canAccessClosed: Bool?
    let deactivated: String?
    
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        case avatarPath = "photo_50"
        case photo100 = "photo_100"
        case isOnline = "online"
        case id
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case deactivated
    }
}

struct UserResponse: Codable {
    let response: UserResponseData
}

// MARK: - Welcome
struct UserResponseData: Codable {
    let count: Int
    let items: [VKUser]
}

var webVKUsers = [VKUser]()





