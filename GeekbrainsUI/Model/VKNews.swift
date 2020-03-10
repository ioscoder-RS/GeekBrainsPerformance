//
//  VKNews.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 01/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

// MARK: Основная сущность новости (топ иерархии)
struct CommonResponseNews: Codable {
    let response: ResponseNews
}

struct ResponseNews: Codable {
    let items: [NewsVK]
    let profiles: [UserVK]
    let groups: [GroupVK]
    let nextFrom: String?

    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
}

struct NewsVK: Codable {
    let id: Int?
    let ownerId: Int?
    let sourceId: Int?
    let fromId: Int?
    let date: Int
    let text: String
    let attachments: [Attachment]?
    let comments: CommentsNews
    let likes: LikesNews
    let reposts: RepostsNews
    let views: ViewsNews?

    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case sourceId = "source_id"
        case fromId = "from_id"
        case date
        case text
        case attachments
        case comments, likes, reposts, views
    }
}

// MARK: - Attachment
struct Attachment: Codable {
    let type: String
    let photo: PhotoNews?
}


struct PhotoNews: Codable {
    let sizes: [Size]
}

struct CommentsNews: Codable {
    let count: Int

    enum CodingKeys: String, CodingKey {
        case count
    }
}

struct LikesNews: Codable {
    let count, userLikes: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
    }
}

struct RepostsNews: Codable {
    let count, userReposted: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

struct ViewsNews: Codable {
    let count: Int
}














//// MARK: Сущность новости с контентом
//struct VKNews: Codable {
//    let items: [NewsResponseItem]       // Массив новостей для текущего пользователя
// //   let profiles: [VKUser]?        // Информация о пользователях
// //   let groups: [VKGroup]?           // Информация о группах
//    let profiles: [FriendsItems]?        // Информация о пользователях
//    let groups: [GroupsItems]?
//    let nextFrom: String                // Получение следующей части новостей
//
//    enum CodingKeys: String, CodingKey {
////        case items
////        case profiles, groups
//        case nextFrom = "next_from"
//    }
//
////    init(from decoder: Decoder) throws {
////        let container = try decoder.container(keyedBy: CodingKeys.self)
//////        items = try container.decode([NewsResponseItem].self, forKey: .items)
//////        profiles = try? container.decode([VKUser].self, forKey: .profiles)
//////        groups = try? container.decode([VKGroup].self, forKey: .groups)
////
//////        profiles = try? container.decode([FriendsItems].self, forKey: .profiles)
//////        groups = try? container.decode([GroupsItems].self, forKey: .groups)
////        nextFrom = try container.decode(String.self, forKey: .nextFrom)
////    }
//}//struct VKNews
//
//// MARK: NewsResponseItem: Массив новостей для текущего пользователя
//struct NewsResponseItem: Codable {
//    //    let id: Int
//    let sourceId: Int, date: Int // Источник новости, время публикации
//    let text: String?                   // Текст записи
//    //  @objc dynamic var attachments: [NewsAttachment]?  // Массив прикрепленных объектов (фото, ссылка etc)
//    //let age = RealmOptional<Int>()
//    // Комментарии
//    let comments: NewsComments?
//    // Лайки к записи
////    let likes:  VKPhotoLikes?
//        let likes: Like?
//    // Репосты
//    let reposts: NewsReposts?
//    // Просмотры записи
//    let views: NewsViews?
//    let photos: [NewsPhoto]
//
//    enum CodingKeys: String, CodingKey {
//        //  case id
//        case date, text, attachments, comments, likes, reposts, views
//        case sourceId = "source_id"
//    }
//
//    enum AttachmentsKeys: String, CodingKey {
//        case type
//    }
//
////    init(from decoder: Decoder) throws {
////
////            let container = try decoder.container(keyedBy: CodingKeys.self)
////
////            //      self.id = try container.decode(Int.self, forKey: .id)
////            self.sourceId = try container.decode(Int.self, forKey: .sourceId)
////            self.date = try container.decode(Int.self, forKey: .date)
////            self.text = try? container.decode(String.self, forKey: .text)
////            self.comments = try? container.decode(NewsComments.self, forKey: .comments)
////            //    self.likes = try? container.decode(VKPhotoLikes.self, forKey: .likes)
////            self.likes = try? container.decode(Like.self, forKey: .likes)
////            self.reposts = try? container.decode(NewsReposts.self, forKey: .reposts)
////            self.views = try? container.decode(NewsViews.self, forKey: .views)
////
////
////            if let attachment = try? container.decode([NewsPhotoAttachment?].self, forKey: .attachments) {
////                self.photos = attachment.compactMap { $0?.photo }
////            } else {
////                self.photos = []
////            }//if let attachment
////    }//    init(from decoder: Decoder) throws
//}//struct NewsResponseItem
//
//    /// Массив объектов новости (фото, ссылка, etc)
//    struct NewsAttachment: Codable {
//        let type: String
//        let photo: NewsPhoto?
//
//    }
//
//    struct NewsPhotoAttachment:  Decodable {
//        let photo: NewsPhoto
//    }
//
//    /// Вложенный объект - фото (Reusing PhotoSizes)
//    class NewsPhoto: Codable {
//      //  let sizes: [VKPhotoSizes]
//        let sizes: [Size]
//    }
//
//    /// Количество комментариев
//    struct NewsComments:  Codable {
//        let count: Int
//    }
//
//    /// Количество просмотров
//    struct NewsViews: Codable {
//        let count: Int
//    }
//
//    /// Количество репостов
//    struct NewsReposts:  Codable {
//        let count: Int
//}
//
//
//
