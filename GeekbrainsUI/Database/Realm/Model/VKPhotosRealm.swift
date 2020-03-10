//
//  VKPhotosRealm.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 29/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import RealmSwift

class VKPhotosRealm: Object {
    @objc dynamic var id = 0
    
    @objc dynamic var albumID = 0
    @objc dynamic var ownerID = 0
    @objc dynamic var text = ""
    @objc dynamic var date = 0
    @objc dynamic var postID = 0
    @objc dynamic var likes: PhotoLikesRealm?
    var sizes = List<PhotoSizesRealm>()
    //     let reposts: Reposts?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func toModel() -> VKPhoto {
        var sizes = [VKPhotoSizes]()
        
        //выгрузка массива sizes
        //MARK: не работает почему-то
        sizes.forEach { size in
            let oneSize = VKPhotoSizes(type: size.type,
                                       url: size.url,
                                       width: size.width,
                                       height: size.height)
            sizes.append(oneSize)
        }// sizes.forEach
        
        //инициализация likes
        //MARK: работает
        let likes = VKPhotoLikes(userLikes: self.likes?.userLikes ?? 0, count: self.likes?.count ?? 0)
        
        return VKPhoto(id: id,
                       albumID: albumID,
                       ownerID: ownerID,
                       sizes: sizes,
                       text: text,
                       date: date,
                       postID: postID,
                       likes: likes,
                       reposts: nil,
                       lat: 0,
                       long: 0)
    }
    
}//class VKUserRealm

class PhotoSizesRealm: Object {
    @objc dynamic var url = ""
    @objc dynamic var type = ""
    @objc dynamic var width = 0
    @objc dynamic var height = 0
}

class PhotoLikesRealm: Object {
    @objc dynamic var userLikes = 0
    @objc dynamic var count = 0
    
    enum CodingKeys: String, CodingKey{
        case userLikes = "user_likes"
        case count
    }
}


