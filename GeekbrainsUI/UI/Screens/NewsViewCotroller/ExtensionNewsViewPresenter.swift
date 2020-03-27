//
//  ExtensionPresenter.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 25/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

extension NewsViewPresenterImplementation {
    
    /// Функция разбивает большую запись о новости на части и заполняет структуры данными для ячеек
    /// - Parameter newsToSlice: новость, в формате из Web,  но приведенная в одну структуру
    func sliceAndAppendNews(newsToSlice:NewsForViewController){
        
        let newsUniqID = String(newsToSlice.newsDate) + "-" + newsToSlice.userName
        
        if newsToSlice.newsDate > self.freshestDateInt {
            self.freshestDateInt = newsToSlice.newsDate
        }
        
        //предотвращаем задвоение новостей
        //выходим из функции если в массиве уже есть новость с таким newsUniqID)
        if  NewsWithSectionsAnyArray.filter ({(GroupsItems) in return Bool(GroupsItems.newsUniqID == newsUniqID )}).count > 0
        {
            return
        }
               
        for ii in 0 ... cellType.count - 1{ //цикл по кол-ву типов ячеек
            switch cellType[ii]{
            case "IconUserTimeCell":
                NewsWithSectionsAnyArray.append(
                    NewsWithSectionsAny(
                        newsUniqID: newsUniqID,
                        cellType: cellType[ii],
                        newsPart: StrIconUserTimeCell(
                            avatarPath: newsToSlice.avatarPath,
                            userName: newsToSlice.userName,
                            newsDate: newsToSlice.newsDate)
                    )
                )
            case "PostAndButton":
                NewsWithSectionsAnyArray.append(
                    NewsWithSectionsAny(
                        newsUniqID: newsUniqID,
                        cellType: cellType[ii],
                        newsPart: StrPostAndButton(
                            newsText: newsToSlice.newsText)
                    )
                )
            case "PhotoCollectionCV":
                NewsWithSectionsAnyArray.append(
                    NewsWithSectionsAny(
                        newsUniqID: newsUniqID,
                        cellType: cellType[ii],
                        newsPart: StrPhotoCollectionCV(
                            newsImages: newsToSlice.newsImages)
                    )
                )
            case "LikesRepostsComments":
                NewsWithSectionsAnyArray.append(
                    NewsWithSectionsAny(
                        newsUniqID: newsUniqID,
                        cellType: cellType[ii],
                        newsPart: StrLikesRepostsComments(
                            newsLikes: newsToSlice.newsLikes,
                            newsReposts: newsToSlice.newsReposts,
                            newsViews: newsToSlice.newsViews,
                            newsComments: newsToSlice.newsComments)
                    )
                )
                case "Gif":
                      NewsWithSectionsAnyArray.append(
                          NewsWithSectionsAny(
                              newsUniqID: newsUniqID,
                              cellType: cellType[ii],
                              newsPart: StrGif(newsGif: newsToSlice.newsGif)
                          )
                      )
                
                case "Link":
                          NewsWithSectionsAnyArray.append(
                              NewsWithSectionsAny(
                                  newsUniqID: newsUniqID,
                                  cellType: cellType[ii],
                                  newsPart: StrLink(url: newsToSlice.newsLinkUrl,
                                                    title: newsToSlice.newsLinkTitle,
                                                    caption: newsToSlice.newsLinkCaption,
                                                    linkDescription: newsToSlice.newsLinkDescription,
                                                    photo: newsToSlice.newsLinkPhotoUrl)
                              )
                          )
                
            default:
                print("неизвестный тип ячеек")
            }
            
        }// for ii
    }// func sliceAndAppendNews()
    
    /// Функция заполняет ячейку содержимым, в зависимости от типа ячейки
    /// - Parameters:
    ///   - tableView: таблица из TableViewController
    ///   - indexPath:  строка indexPath
    func getTableviewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        var currentCell = UITableViewCell()
        
        guard let currentNews = self.getCurrentNewsAtIndexSection( indexPath: indexPath) else {return currentCell}
             
        let rowType = currentNews.cellType
        
        switch rowType {
        //иконка, дата время поста
        case "IconUserTimeCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "iconUserTimeCell", for: indexPath) as! IconUserTimeCell
            let localStruct = currentNews.newsPart as! StrIconUserTimeCell
            cell.renderCell(
                iconURL: localStruct.avatarPath,
                newsAuthor:localStruct.userName + currentNews.newsUniqID,
                newsTime: viewableUnixTime(unixTime: localStruct.newsDate)
            )
            currentCell = cell
            
        //текст поста и кнопка "Подробнее"
        case "PostAndButton":
            let cell = tableView.dequeueReusableCell(withIdentifier: "postAndButton", for: indexPath) as! PostAndButton
            let localStruct = currentNews.newsPart as! StrPostAndButton
            cell.renderCell(
                newstext: localStruct.newsText
            )
            cell.buttonDelegate = self
            
            currentCell = cell
            
        //коллекшн с фото
        case "PhotoCollectionCV":
            let cell = tableView.dequeueReusableCell(withIdentifier: "photoCollectionTableViewCell", for: indexPath) as! PhotoCollectionTableViewCell
            let localStruct = currentNews.newsPart as! StrPhotoCollectionCV
           
            cell.imageHeightDelegate = self
            let count = localStruct.newsImages.count
            
            if count > 0 {
            cell.renderCollection(
                imagesArray: localStruct.newsImages,
                imageCount: count
            )
            }
            
            //обновляем данные встроенного CollectionView
            cell.newsPhotoCollectionView.reloadData()
            currentCell = cell
            
        //лайки, репосты, комменты
        case "LikesRepostsComments":
            let cell = tableView.dequeueReusableCell(withIdentifier: "likesRepostsComments", for: indexPath) as! LikesRepostsComments
            let localStruct = currentNews.newsPart as! StrLikesRepostsComments
            cell.renderCell(likesNews: localStruct.newsLikes,
                            repostsNews: localStruct.newsReposts,
                            viewsNews: localStruct.newsViews,
                            commentsNews: localStruct.newsComments)
            currentCell = cell
            
        //GIF-ки
        case "Gif":
            let cell = tableView.dequeueReusableCell(withIdentifier: "gifCell", for: indexPath) as! GifCell
            let localStruct = currentNews.newsPart as! StrGif
            if localStruct.newsGif != ""{ cell.renderCell(gifURL: localStruct.newsGif) }
            currentCell = cell
            
        //Link
        case "Link":
            let cell = tableView.dequeueReusableCell(withIdentifier: "linkCell", for: indexPath) as! LinkCell
            let localStruct = currentNews.newsPart as! StrLink

            if localStruct.url != ""{
                cell.renderCell (strLink: localStruct)
            }
            currentCell = cell
            
        default:
            print("☹️ Ой")
            return UITableViewCell()
        }//switch rowType
        
        return currentCell
    }//func getTableviewCell
}
