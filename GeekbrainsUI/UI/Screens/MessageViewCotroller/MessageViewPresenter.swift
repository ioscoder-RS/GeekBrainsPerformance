//
//  MessageViewPresenter.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 01/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import Foundation


protocol MessageViewPresenter {
    func viewDidLoad()
    func numberOfRows() -> Int
    func getCurrentNewsAtIndex(indexPath: IndexPath) -> NewsForViewController?
}

class MessageViewPresenterImplementation: MessageViewPresenter {
    private var vkAPI: VKAPi
    private weak var view: MessageView?
    var newsRepository = NewsRepository() // это получается из БД
    var newsResult: [NewsForViewController]! //это выводится в tableView
    
    private var newsDB: NewsSource
    
    init (newsDB: NewsSource, view: MessageView){
        self.view = view
        self.newsDB = newsDB
        vkAPI = VKAPi()
    }
    
    
    
    func viewDidLoad(){
        getNewsFromApiAndDB()
    }
    
    func getNewsFromDatabase(){
        self.newsResult = newsDB.getAllNews()
        self.view?.updateTable()
    }//func getGroupsFromDatabase()
    
    func  getNewsFromApiAndDB(from: String? = nil){
        if webMode{
            //Получаем пользователей из Web
            vkAPI.getNewsList(token: Session.shared.token, userId: Session.shared.userId, from: nil, version: Session.shared.version){  result in
                switch result {
                case .success(let webNews): //массив VKNews из Web
                    do{
                        try self.newsDB.createNewsForView(sourceNews: webNews)
                        //выгружаем из БД строго после Web-запроса и после добавления в БД
                        self.getNewsFromDatabase()
                    }catch {
                        print("we got error in newsDB.createNewsForView(): \(error)")
                    }
                case .failure(let error):
                    print("we got error in getNewsfeed(): \(error)")
                }//switch
            }//completion
        }// if webMode{
        else
        {
            self.getNewsFromDatabase()
        }
    }//func  getGroupsFromApiAndDB()
    
}//class GroupPresenterImplementation

extension MessageViewPresenterImplementation {
    func numberOfRows() -> Int {
        return newsResult?.count ?? 0
    }
    func getCurrentNewsAtIndex(indexPath: IndexPath) -> NewsForViewController? {
        return newsResult![indexPath.row]
    }
}


