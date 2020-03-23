//
//  VKGroup.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 19/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

struct VKGroup: Codable {
    let id: Int
    let name, screenName: String
    let isClosed: Int
    let type: String
    let isAdmin, isMember, isAdvertiser: Int?
    let activity: String?
    let membersCount: Int?
    let photo100: String
    let adminLevel: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case activity
        case membersCount = "members_count"
        case photo100 = "photo_100"
        case adminLevel = "admin_level"
    }
}


struct GroupResponse: Codable {
    let response: GroupResponseData
}

// MARK: - Response
struct GroupResponseData: Codable {
    let count: Int
    let items: [VKGroup]
}

var webVKGroups = [VKGroup]()

