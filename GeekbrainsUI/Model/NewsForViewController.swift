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

let cellType:[String] =
    [
        "IconUserTimeCell",
        "PostAndButton",
        "PhotoCollectionCV",
        "LikesRepostsComments"
]

//предполагается, что на один пост будет сохранено
// celltype.count ячеек каждая своего типа
struct NewsWithSections {
    var newsUniqID : String //userName+"-"+newsDate
    var newsArray: NewsForViewController
    var cellType: String
}

var newsSections = [NewsWithSections]()

//MARK: для реализации "распиленной" по типам ячеек новости и общей Generic структуры новостей

struct NewsWithSectionsAny {
    var newsUniqID : String //newsDate + "-" + userName
    var cellType: String
    var newsPart: Any
}


struct StrIconUserTimeCell {
    var avatarPath:     String
    var userName:       String
    var newsDate:       Int
}

struct StrPostAndButton {
    var newsText:       String
}

struct StrPhotoCollectionCV{
    var newsImages:     [String]
}

struct StrLikesRepostsComments {
    var newsLikes: LikesNews
    var newsReposts: RepostsNews
    var newsViews: ViewsNews
    var newsComments: CommentsNews

}
