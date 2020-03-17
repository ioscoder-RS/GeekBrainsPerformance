//
//  MessageViewPresenter.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 01/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit


protocol NewsViewPresenter {
    func viewDidLoad()
    
    //MARK: функции для TableViewController с секциями
    func numberOfRows() -> Int
    func getCurrentNewsAtIndex(indexPath: IndexPath) -> NewsForViewController?
    
    //MARK: функции для TableViewController с секциями
    func numberOfRowsInSection(section: Int) -> Int
    func getCurrentNewsAtIndexSection(indexPath: IndexPath) -> NewsWithSectionsAny?
    func numberOfSections() -> Int
    func getSectionIndexTitles() -> [String]?
    func getTableviewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func fetchMoreNews(tableView: UITableView, indexPaths: [IndexPath])
    func getRowHeight(tableView: UITableView, indexPath: IndexPath) -> CGFloat
}

class NewsViewPresenterImplementation: NewsViewPresenter {
    private var vkAPI: VKAPi
    private weak var view: MessageView?  //класс TableView, где все отображается
    var newsRepository = NewsRepository() // массив новостей, полученный из БД
    var newsResult = [NewsForViewController]() //запрос, считанный с сервера ВК (единая структура)
    
    private var NewsWithSectionsAnyArray = [NewsWithSectionsAny]() //новость, разбитая внутри класса на секции
    private var sortedNewsResults = [Section<NewsWithSectionsAny>]() //массив с секциями, отображаемый в TableView
    
    var customRefreshControl = UIRefreshControl() //для дозагрузки обновлений в новости
//    var freshestDate: String?
    
    private var newsDB: NewsSource
    
    var isFetchingMoreNews = false  //загружаем более старые новости или нет
    var nextFrom: String? //с какой отметки загружать новости
    var freshestDateInt = 0
    
    var imageLoadQueue = DispatchQueue(label: "GeekbrainsUI.images.posts", attributes: .concurrent)
    
    init (newsDB: NewsSource, view: MessageView){
        self.view = view
        self.newsDB = newsDB
        vkAPI = VKAPi()
    }
    
    func viewDidLoad(){
        addRefreshControl()
        
        self.newsResult = [NewsForViewController]()
        getNewsFromApiAndDB()
    }
    
    func getNewsFromDatabase(){
        self.newsResult = newsDB.getAllNews()
        self.makeSections()
        self.sortForTableView()
        self.view?.updateTable()
    }//func getGroupsFromDatabase()
    
    func getNextFrom()-> String?{
        //здесь будет получение nextFrom из Realm
        return nil
    }
    
    func  getNewsFromApiAndDB(from: String? = nil){
        if webMode{
            //Получаем значение nextFrom
            self.nextFrom = getNextFrom()
            
            
            //Получаем пользователей из Web
            imageLoadQueue.async {
                self.isFetchingMoreNews = true
                self.vkAPI.getNewsList(token: Session.shared.token, userId: Session.shared.userId, nextFrom: self.nextFrom, startTime: nil, version: Session.shared.version){  result in
                    switch result {
                    case .success(let webNews): //массив VKNews из Web
                        do{
                            self.nextFrom = webNews.nextFrom
                            try
                                DispatchQueue.main.async {
                                    self.newsDB.createNewsForView(sourceNews: webNews)
                                    //выгружаем из БД строго после Web-запроса и после добавления в БД
                                    self.getNewsFromDatabase()
                                }//DispatchQueue.main.async
                        }catch {
                            print("we got error in newsDB.createNewsForView(): \(error)")
                        }
                    case .failure(let error):
                        print("we got error in getNewsfeed(): \(error)")
                    }//switch
                    self.isFetchingMoreNews = false
                }//completion
            }//imageLoadQueue.async
        }// if webMode{
        else
        {
            self.getNewsFromDatabase()
        }
    }//func  getGroupsFromApiAndDB()
    
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
            default:
                print("ой")
                return
            }
            
        }// for ii
    }// func sliceAndAppendNews()
  
    func sortForTableView(){
        let groupedNews = Dictionary.init(grouping: NewsWithSectionsAnyArray){$0.newsUniqID }
        //        let groupedNews = Dictionary.init(grouping: newsResult!){$0.newsDate }
        sortedNewsResults = groupedNews.map { Section(title: String($0.key), items: $0.value) }
        sortedNewsResults.sort {$0.title > $1.title}
        
    }
    
    func makeSections(){
        
        //*      guard let localNewsResult = newsResult else {return}
        let localNewsResult = newsResult
        
        let newsResultcount = localNewsResult.count
        print("newsResultCount = \(newsResultcount)")
        print("число сообщений \(self.numberOfSections())")
        
        if newsResultcount > 0{
            // размножаем новость по количеству типов ячеек
            for i in 0 ... newsResultcount - 1 { //цикл по кол-ву новостей
                sliceAndAppendNews(newsToSlice: localNewsResult[i])
            }// for i
    
        }//if
        //  print ("заполнили makeSections: \n \(newsSections)")
        
    }
    

    
}//class GroupPresenterImplementation

extension NewsViewPresenterImplementation {
    //MARK: функции для TableViewController без секций
    func numberOfRows() -> Int {
        //*       return newsResult?.count ?? 0
        return newsResult.count
    }
    func getCurrentNewsAtIndex(indexPath: IndexPath) -> NewsForViewController? {
        //*      return newsResult?[indexPath.row]
        return newsResult[indexPath.row]
        //   return newsSections[indexPath.section].newsArray
    }
    
    //MARK: функции для TableViewController с секциями
    func numberOfRowsInSection(section: Int) -> Int {
        let count = sortedNewsResults[section].items.count
        if count > 4{
            print("задвоилось: count = \(count)")
        }
        return count
    }
    
    //*  func getCurrentNewsAtIndexSection(indexPath: IndexPath) -> NewsWithSections? {
    func getCurrentNewsAtIndexSection(indexPath: IndexPath) -> NewsWithSectionsAny? {
        return sortedNewsResults[indexPath.section].items[indexPath.row]
    }
    
    func numberOfSections() -> Int {
        return sortedNewsResults.count
    }
    
    func getSectionIndexTitles() -> [String]? {
        return sortedNewsResults.map{$0.title}
    }
    
    
    
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
                newsAuthor:localStruct.userName,
                newsTime: convertUnixTime(unixTime: localStruct.newsDate)
            )
            currentCell = cell
            
        //текст поста и кнопка "Подробнее"
        case "PostAndButton":
            let cell = tableView.dequeueReusableCell(withIdentifier: "postAndButton", for: indexPath) as! PostAndButton
            let localStruct = currentNews.newsPart as! StrPostAndButton
            cell.renderCell(
                newstext: localStruct.newsText
            )
            currentCell = cell
            
        //коллекшн с фото
        case "PhotoCollectionCV":
            let cell = tableView.dequeueReusableCell(withIdentifier: "photoCollectionTableViewCell", for: indexPath) as! PhotoCollectionTableViewCell
            let localStruct = currentNews.newsPart as! StrPhotoCollectionCV
            
            cell.renderCell(
                imagesArray: localStruct.newsImages
            )
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
            
            
        default:
            print("☹️ Ой")
            return UITableViewCell()
        }//switch rowType
        
        return currentCell
    }//func getTableviewCell
    
    func fetchMoreNews(tableView: UITableView, indexPaths: [IndexPath]) {
        let maxRow = indexPaths.map({ $0.section }).max()
        
        guard !isFetchingMoreNews else {
            if debugPrefetchMode {  print("🙅‍♂️ Флаг не дал запустить запрос ")    }
            return
        }
        guard   maxRow != nil,
            newsResult.count  <= maxRow! + 3  else { return }
        
        
        
        self.isFetchingMoreNews = true
        if debugPrefetchMode {  print("✅ isFetchingMoreNews = \(self.isFetchingMoreNews), дата = \(Date())")  }
        if debugPrefetchMode {  print("запрос стартовал")   }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.vkAPI.getNewsList(token: Session.shared.token, userId: Session.shared.userId, nextFrom: self.nextFrom, startTime: nil, version: Session.shared.version) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let posts):
                    if debugPrefetchMode {  print("🏁 completion success: \(Date())")   }
                    //приводим результат с сервера к виду, с которым будем работать в этом классе
                    self.newsDB.createNewsForView(sourceNews: posts)
                    //сохраняем массив новополученных новостей в переменную
                    self.newsResult = self.newsDB.getAllNews()
                    //разбиваем полученный результат на части, превращаем в секции
                    self.makeSections()
                    // сортируем данные и группируем по секциям
                    self.sortForTableView()
                    //сохраняем nextFrom
                    self.nextFrom = posts.nextFrom
                    
                    self.view?.updateTable()
                    self.isFetchingMoreNews = false
                    if debugPrefetchMode {  print(" 🛑 isFetchingMoreNews = \(self.isFetchingMoreNews), дата = \(Date())")  }
                case .failure(let error):
                    self.isFetchingMoreNews = false
                    if debugPrefetchMode {  print("  isFetchingMoreNews = \(self.isFetchingMoreNews), дата = \(Date())")    }
                    print(error)
                }//switch result
            }// completion
        }// DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
    }//func fetchMoreNews()
    
    func getRowHeight(tableView: UITableView, indexPath: IndexPath) -> CGFloat {
        let rowType = indexPath.row
        switch rowType {
        //коллекшн с фото
        case 2:
            let currentNews = self.getCurrentNewsAtIndexSection(indexPath: indexPath)
            let localStruct = currentNews?.newsPart as! StrPhotoCollectionCV
            switch(localStruct.newsImages.count) {
            case 0:
                return 0
            default:
                return 300
            }
            
        default:
            return UITableView.automaticDimension
        }
    }//func getRowHeight
    
    func addRefreshControl(){
        customRefreshControl.attributedTitle = NSAttributedString(string:"refreshing...")
        customRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        self.view?.addSubView(view: customRefreshControl)
    }
    
    @objc func refreshTable(){
        
  
            self.isFetchingMoreNews = true
            self.vkAPI.getNewsList(token: Session.shared.token, userId: Session.shared.userId, nextFrom: nil, startTime: String(self.freshestDateInt + 1), version: Session.shared.version) { [weak self] result in
                   guard let self = self else { return }
                   switch result {
                   case .success(let posts):
                      
                      if posts.items.count > 0 {
                       //приводим результат с сервера к виду, с которым будем работать в этом классе
                       self.newsDB.createNewsForView(sourceNews: posts)

                       //сохраняем массив новополученных новостей в переменную
                       self.newsResult = self.newsDB.getAllNews()

                       //разбиваем полученный результат на части, превращаем в секции
                       self.makeSections()

                        // сортируем данные и группируем по секциям
                        self.sortForTableView()

                       self.view?.updateTable()
                      }//if posts.items.count > 0
                      
                  
                   case .failure(let error):
                       print(error)
                   }
               }
             self.isFetchingMoreNews = false
            self.customRefreshControl.endRefreshing()

    } //@objc func refreshTable(){
}// extension


