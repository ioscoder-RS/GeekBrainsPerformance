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
    let profiles: [VKUser]
    let groups: [VKGroup]
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
    let postType: String
    let text: String
    let attachments: [Attachment]?
    let comments: CommentsNews
    let likes: LikesNews
    let reposts: RepostsNews
    let views: ViewsNews?
    let postSource: PostSource
    let postID: Int?
    let markedAsAds: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case sourceId = "source_id"
        case fromId = "from_id"
        case date
        case postType = "post_type"
        case text
        case attachments
        case comments, likes, reposts, views
        case postSource = "post_source"
        case postID = "post_id"
        case markedAsAds = "marked_as_ads"
    }
}


// MARK: - Attachment
struct Attachment: Codable {
    let type: String
    let photo: AttachmentPhoto?
    let doc: Doc?
    let link: Link?
}

// MARK: - Doc
struct Doc: Codable {
    let id, ownerID: Int
    let title: String
    let size: Int?
    let ext: String?
    let url: String?
    let date, type: Int?
    let preview: Preview?
    let accessKey: String?

    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case title, size, ext, url, date, type, preview
        case accessKey = "access_key"
    }
}

// MARK: - Link
struct Link: Codable {
    let url: String
    let title: String
    let caption: String?
    let linkDescription: String?
    let photo: LinkPhoto?
    let isFavorite: Bool?

    enum CodingKeys: String, CodingKey {
        case url, title, caption
        case linkDescription = "description"
        case photo
        case isFavorite = "is_favorite"
    }
            
}

// MARK: - LinkPhoto
struct LinkPhoto: Codable {
    let id, albumID, ownerID: Int
    let sizes: [Video]
    let text: String?
    let date: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case albumID = "album_id"
        case ownerID = "owner_id"
        case sizes, text, date
    }
}

// MARK: - AttachmentPhoto
struct AttachmentPhoto: Codable {
    let id, albumID, ownerID, userID: Int
    let sizes: [Video]
    let text: String?
    let date: Int?
    let postID: Int?
    let accessKey: String?

    enum CodingKeys: String, CodingKey {
        case id
        case albumID = "album_id"
        case ownerID = "owner_id"
        case userID = "user_id"
        case sizes, text, date
        case postID = "post_id"
        case accessKey = "access_key"
    }
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

// MARK: - Preview
struct Preview: Codable {
    let photo: PreviewPhoto?
    let video: Video?
}

// MARK: - PreviewPhoto
struct PreviewPhoto: Codable {
    let sizes: [Video]
}

// MARK: - Video
struct Video: Codable {
    let src: String?
    let width, height: Int
    let type: String?
    let fileSize: Int?
    let url: String?
    
    var aspectRatio: CGFloat? {
          guard width != 0 else { return nil }
          return CGFloat(height)/CGFloat(width)
      }
    
    enum CodingKeys: String, CodingKey {
        case src, width, height, type
        case fileSize = "file_size"
        case url
    }
}

// MARK: - PostSource
struct PostSource: Codable {
    let type: String
}
