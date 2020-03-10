//
//  NewsForViewController.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 06/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

// структура новости для отображения
struct NewsForViewController {
    var avatarPath:     String
    var userName:       String
    var newsDate:       Int
    var newsText:       String
    var newsImages:     [String]
  //  var newsLikes: VKPhotoLikes
    var newsLikes: LikesNews
    var newsReposts: RepostsNews
    var newsViews: ViewsNews
    var newsComments: CommentsNews
}

var newsViewArray = [NewsForViewController]()
