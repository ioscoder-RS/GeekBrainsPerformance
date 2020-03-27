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
        var parsedGif: String?
 //       var photoArray = [String]()
        var photoArray = [Video]()
        var parsedLinkUrl : String?
        var parsedLinkTitle : String?
        var parsedLinkCaption : String?
        var parsedLinkDescription : String?
        var parsedLinkPhotoUrl: String?
        var parsedLinkIsFavorite : Bool?
        
        //обнуляем массив, т.к. он может быть не пустым
        //например: при инициирующей загрузке его заполнили, а потом в prefetchRowsAt начали подкачивать
        newsViewArray = [NewsForViewController]()
        
        for a in 0 ... sourceNews.items.count - 1 {
            
            photoArray = [Video]()
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
          //обнуляем переменную с URL-адресом GIF
                   parsedGif = nil
 
            //обнуляем переменные link
             parsedLinkUrl =  ""
             parsedLinkTitle = ""
             parsedLinkCaption =  ""
             parsedLinkDescription = ""
             parsedLinkPhotoUrl = ""
             parsedLinkIsFavorite = false
            
            let attachArray = sourceNews.items[a].attachments ?? []
            if attachArray.count > 0{
                for i in 0 ... attachArray.count  - 1 {
                    switch attachArray[i].type{
                    case "photo":
                        let localSizes = attachArray[i].photo?.sizes
   //                     let url = localSizes?.first(where: {$0.type == "x"})?.url
                        guard let sizes = localSizes?.first(where: {$0.type == "x"}) else { return  }
   //                     photoArray.append(url ?? "")
                        photoArray.append(sizes)
                    case "doc":
                        if attachArray[i].doc?.type == 3 {
                            parsedGif = attachArray[i].doc?.url
                        }
                    case "link":
                        //обнуляем переменные link
                         parsedLinkUrl =  ""
                         parsedLinkTitle = ""
                         parsedLinkCaption =  ""
                         parsedLinkDescription = ""
                         parsedLinkPhotoUrl = ""
                         parsedLinkIsFavorite = false
                         
                         //парсим значения
                        parsedLinkUrl = attachArray[i].link?.url ?? ""
                        parsedLinkTitle = attachArray[i].link?.title ?? ""
                        parsedLinkCaption = attachArray[i].link?.caption ?? ""
                        parsedLinkDescription = attachArray[i].link?.linkDescription ?? ""
                        
                        let localSizes = attachArray[i].link?.photo?.sizes
                        let url = localSizes?.first(where: {$0.type == "l"})?.url
                        
                        parsedLinkPhotoUrl = url
                        
                        parsedLinkIsFavorite = attachArray[i].link?.isFavorite
                        
                    default:
                        break
                    }//switch
                }//for
            }//if
            
            
            newsViewArray.append(NewsForViewController(
                avatarPath: parsedPhoto,
                userName: parsedUsername,
                newsDate: sourceNews.items[a].date,
                newsText: sourceNews.items[a].text ,
                newsImages: photoArray,
                newsLikes: sourceNews.items[a].likes,
                newsReposts: sourceNews.items[a].reposts,
                newsViews: sourceNews.items[a].views ?? ViewsNews(count: 0),
                newsComments: sourceNews.items[a].comments,
                newsGif: parsedGif ?? "",
                newsLinkUrl: parsedLinkUrl ?? "",
                newsLinkTitle: parsedLinkTitle ?? "",
                newsLinkCaption: parsedLinkCaption ?? "",
                newsLinkDescription: parsedLinkDescription ?? "",
     //           newsLinkPhoto: LinkPhoto ?? "",
                newsLinkPhotoUrl: parsedLinkPhotoUrl ?? "",
                newsLinkIsFavorite: parsedLinkIsFavorite ?? false
               
                
            ))
            
            //    print(newsViewArray)
        }
    }
}


