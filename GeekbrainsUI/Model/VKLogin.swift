//
//  VKLogin.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 19/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import Foundation

// MARK: - Последний = текущий логин


var webVKLogin = [VKLogin]()

struct LoginResponse: Codable {
    let response: [LoginResponseData]
}

struct LoginResponseData: Codable {
    let response: [VKLogin]
}


// MARK: - Текущий логин
struct VKLogin: Codable {
    let id: Int
    let firstName, lastName: String
    let isClosed, canAccessClosed: Bool
    let city: City?
    let avatarPath: String
    let verified: Int

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case city
        case avatarPath = "photo_50"
        case verified
    }
}

// MARK: - City
struct City: Codable {
    let id: Int
    let title: String
}
