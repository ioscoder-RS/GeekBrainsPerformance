//
//  MessageRepository.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 01/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import Foundation

protocol NewsSource{
    func getAllNews() -> [NewsForViewController]
    func createNewsForView (sourceNews: ResponseNews)
}

class NewsRepository: NewsSource {
    func getAllNews() -> [NewsForViewController] {
        return newsViewArray
        //потом здесь будет Realm
    }
    
    func createNewsForView (sourceNews: ResponseNews){
        var parsedPhoto: String = ""
        var parsedUsername: String = ""
        var photoArray = [String]()
        
        //обнуляем массив, т.к. он может быть не пустым
        //например: при инициирующей загрузке его заполнили, а потом в prefetchRowsAt начали подкачивать
        newsViewArray = [NewsForViewController]()
        
        for a in 0 ... sourceNews.items.count - 1 {
            
            photoArray = [String]()
            let tmpSourceId = sourceNews.items[a].sourceId!
            //извлекаем фото
            if  tmpSourceId > 0 {
                //значит извлекаем из массива пользователей
                let tempArray = sourceNews.profiles.filter({(FriendsItems) in return Bool(FriendsItems.id == tmpSourceId )})
                
                parsedUsername = tempArray[0].firstName + " " + tempArray[0].lastName
                parsedPhoto = tempArray[0].photo100            }
            else {
                //значит извлекаем из массива групп
                let tempArray = sourceNews.groups.filter({(GroupsItems) in return Bool(GroupsItems.id == -(tmpSourceId) )})
                parsedUsername = tempArray[0].name
                parsedPhoto = tempArray[0].photo100
            }
            
            let attachArray = sourceNews.items[a].attachments ?? []
            if attachArray.count > 0{
                for i in 0 ... attachArray.count  - 1 {
                    if attachArray[i].type == "photo" {
                        let localSizes = attachArray[i].photo?.sizes
                        let url = localSizes?.first(where: {$0.type == "x"})?.url
                        photoArray.append(url ?? "")
                    }
                }
            }
            
            if photoArray.count > 0 {
    //            print("у нас есть photoArray! username = \(parsedUsername) кол-во фото: \(photoArray.count)")
            }
            
            newsViewArray.append(NewsForViewController(
                avatarPath: parsedPhoto,
                userName: parsedUsername,
                newsDate: sourceNews.items[a].date,
                newsText: sourceNews.items[a].text ,
                newsImages: photoArray,
                newsLikes: sourceNews.items[a].likes,
                newsReposts: sourceNews.items[a].reposts,
                newsViews: sourceNews.items[a].views,
                newsComments: sourceNews.items[a].comments
                
            ))
            
            //    print(newsViewArray)
        }
    }
}


