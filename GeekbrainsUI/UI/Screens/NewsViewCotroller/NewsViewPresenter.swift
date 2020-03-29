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
    func numberOfRowsInSection(section: Int) -> Int
    func getCurrentNewsAtIndexSection(indexPath: IndexPath) -> NewsWithSectionsAny?
    func numberOfSections() -> Int
    func getSectionIndexTitles() -> [String]?
    func getTableviewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func fetchMoreNews(tableView: UITableView, indexPaths: [IndexPath])
    func getRowHeight(tableView: UITableView, indexPath: IndexPath) -> CGFloat
}

/// реализация кода для TableView, который задается протоколом NewsViewPresenter
/// протокол MoreButtonProtocol связывает класс с ячейкой PostAndButton чтобы отреагировать на нажатую в ней кнопку
class NewsViewPresenterImplementation: NewsViewPresenter, MoreButtonProtocol, ImageHeightDefined {

    private var vkAPI: VKAPi
    private weak var view: MessageView?  //класс TableView, где все отображается
    var newsRepository = NewsRepository() // массив новостей, полученный из БД
    var newsResult = [NewsForViewController]() //запрос, считанный с сервера ВК (единая структура)
    
     var NewsWithSectionsAnyArray = [NewsWithSectionsAny]() //новость, разбитая внутри класса на секции
    private var sortedNewsResults = [Section<NewsWithSectionsAny>]() //массив с секциями, отображаемый в TableView
    private var selfProfile: VKUser? //профиль текущего пользователя
    private var previousProfileID: String = ""
    
    var customRefreshControl = UIRefreshControl() //для дозагрузки обновлений в новости

    private var newsDB: NewsSource
    private var loginDB = LoginRepository()
    
    var isFetchingMoreNews = false  //загружаем более старые новости или нет
    var isProfileLoading = false //загружаем ли профайл пользователя
    var nextFrom: String? //с какой отметки загружать новости
    var freshestDateInt = 0
    
    var imageLoadQueue = DispatchQueue(label: "GeekbrainsUI.images.posts", attributes: .concurrent)
    
    init (newsDB: NewsSource, view: MessageView){
        self.view = view
        self.newsDB = newsDB
        vkAPI = VKAPi()
    }
    
    func viewDidLoad(){
        //добавляем крутящееся колесико для обновления информации
        addRefreshControl()
        //получаем профайл пользователя
        getProfileInformation()
        //получаем новости
        getNewsFromApiAndDB()
    }
    
    
    /// Заглушка будущей реализации, когда работаем без интернета, но новости храним в БД и забираем из БД
    //MARK: 🙅‍♂️ Не используется
    func getNewsFromDatabase(){
        //сохраняем массив новополученных новостей в переменную
        self.newsResult = self.newsDB.getAllNews()
        //разбиваем полученный результат на части, превращаем в секции
        self.makeSections()
        // сортируем данные и группируем по секциям
        self.sortForTableView()
    }//func getGroupsFromDatabase()
    
    func getNextFrom()-> String?{
        //здесь будет получение nextFrom из Realm
        return nil
    }
    
    func getProfileInformation()
    {
        if webMode{
            //Получаем пользователей из Web
            imageLoadQueue.async {
                self.vkAPI.getLogin(token: Session.shared.token, loginId: Session.shared.userId){
                    result in
                    switch result{
                    case .success(let profile):
                        self.selfProfile = profile.first

                    case .failure(let error):
                        print("we got error in NewsPresenter -> vkAPI.getLogin: \(error)")
                    }//switch
                    
                }//vkAPI.getLogin completion
            }//imageLoadQueue.async
        } else {
            self.selfProfile = loginDB.getLogin()
        }//if webMode{
    }//func getProfileInformation()
    
    /// функция первичной загрузки данных из Web
    /// в настоящее время сохранение в БД не реализовано, но заглушки расставлены
    /// - Parameter from: 🙅‍♂️ пока не используется, заглушка для возможности вызова из различных мест
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
                     self.workWithNewsWebQuery(responseNews: webNews)
                    case .failure(let error):
                        print("we got error in getNewsfeed(): \(error)")
                    }//switch
                    self.isFetchingMoreNews = false
                }//completion
            }//imageLoadQueue.async
        }// if webMode{
        else
            //MARK: 🙅‍♂️ не используется. Не тестировалось
        {
            self.getNewsFromDatabase()
        }
    }//func  getGroupsFromApiAndDB()
    
    /// Функция разбивает структуру новостей на подструктуры-секции
    func makeSections(){
        let localNewsResult = newsResult
        let newsResultcount = localNewsResult.count
             
        if newsResultcount > 0{
            // размножаем новость по количеству типов ячеек
            for i in 0 ... newsResultcount - 1 { //цикл по кол-ву новостей
                sliceAndAppendNews(newsToSlice: localNewsResult[i])
            }// for i
        }//if
    }//func makeSections(){
    
    /// Функция добавляет в tableView запись о профиле пользователя
    /// Вначале удаляет предыдущую запись о профиле, тк в ключ (дата+пользователь)  входит текущая дата
    /// это нужно для того, чтобы пользовательский профиль всегда был наверху
    /// - Parameter profile: структура профиля пользователя
    func prepareProfileForView(profile: VKUser){
        if profile == nil {return}
        
        guard self.isProfileLoading == false else {return}
        
        self.isProfileLoading = true
        
        //удаляем пред. запись о профиле
  //      NewsWithSectionsAnyArray = NewsWithSectionsAnyArray.filter{$0.newsUniqID != self.previousProfileID}
        NewsWithSectionsAnyArray.removeAll(where: {$0.newsUniqID == self.previousProfileID})
        
        
        let unixTime = NSDate().timeIntervalSince1970 + 1000 //запас ?
        let newsUniqID = String(Int(unixTime)) + "-" + profile.fullName
        
        NewsWithSectionsAnyArray.append(
            NewsWithSectionsAny(
                newsUniqID: newsUniqID,
                cellType: "SelfProfile",
                newsPart: StrSelfProfile(
                    id: profile.id,
                    avatarPath: profile.avatarPath,
                    lastName: profile.lastName,
                    firstName: profile.firstName,
                    fullName: profile.fullName
                )
            )
      
        )
        print(" 🛑 вставляем запись о профайле в структуру. NewsUniqID = \(newsUniqID), дата = \(Date())")
        self.previousProfileID = newsUniqID
         self.isProfileLoading = false
    }
    
    /// функция сортирует массив по секциям и строкам
    func sortForTableView(){
        let groupedNews = Dictionary.init(grouping: NewsWithSectionsAnyArray){$0.newsUniqID }
        sortedNewsResults = groupedNews.map { Section(title: String($0.key), items: $0.value) }
        sortedNewsResults.sort {$0.title > $1.title}
    }
    
    /// Функциия берет распарсенную новость из Web, преобразовывает и отображает
    /// - Parameter responseNews: распарсенный запрос новости из VKApi.getNewsFeed
    func workWithNewsWebQuery(responseNews: ResponseNews){
        
        //приводим результат с сервера к виду, с которым будем работать в этом классе
        self.newsDB.createNewsForView(sourceNews: responseNews)
        //сохраняем массив новополученных новостей в переменную
        self.newsResult = self.newsDB.getAllNews()
        //разбиваем полученный результат на части, превращаем в секции
        self.makeSections()
        //добавляем запись о профиле - она должна быть всегда вверху
        if !isProfileLoading{
        self.prepareProfileForView(profile: self.selfProfile!)
        }
        // сортируем данные и группируем по секциям
        self.sortForTableView()
        //сохраняем nextFrom
        self.nextFrom = responseNews.nextFrom
        
        //перерисовка контроллера
        self.view?.updateTable()
      }

    
    /// Функция загружает порцию более старых новостей
    /// - Parameters:
    ///   - tableView: таблица из TableViewController
    ///   - indexPath:  строка indexPath
      func fetchMoreNews(tableView: UITableView, indexPaths: [IndexPath]) {
          let maxRow = indexPaths.map({ $0.section }).max()
          
          guard   maxRow != nil,
              sortedNewsResults.count  <= maxRow! + 3  else { return }
        
        guard !isFetchingMoreNews else {
            if debugPrefetchMode {  print("🙅‍♂️ Флаг не дал запустить запрос ")    }
            return
        }
          //выставляем флаг загрузки новостей
        //пока флаг включен - новости не грузим, иначе вовремя массового скроллинга будет коллапс загрузок новостей
          self.isFetchingMoreNews = true

          imageLoadQueue.async {
              self.vkAPI.getNewsList(token: Session.shared.token, userId: Session.shared.userId, nextFrom: self.nextFrom, startTime: nil, version: Session.shared.version) { [weak self] result in
                  guard let self = self else { return }
                  switch result {
                  case .success(let posts):
                      if debugPrefetchMode {  print("🏁 completion success: \(Date())")   }
                      
                      //сохраняем запрос, приводим к формату, разбиваем на секции, добавляем к текущему массиву и отображаем в TableView
                    if debugPrefetchMode {  print(" ✅ isFetchingMoreNews = \(self.isFetchingMoreNews), дата = \(Date())")  }
                      self.workWithNewsWebQuery(responseNews: posts)
                      //сбрасываем флаг загрузки новостей
                      self.isFetchingMoreNews = false
    
                  case .failure(let error):
                      self.isFetchingMoreNews = false
                      print(error)
                  }//switch result
              }// completion
          }// imageLoadQueue.async {
      }//func fetchMoreNews()
      

    /// Функция определяет высоту строки tableView в зависимости от типа ячейки
    /// - Parameters:
    ///   - tableView: таблица из TableViewController
    ///   - indexPath:  строка indexPath
    func getRowHeight(tableView: UITableView, indexPath: IndexPath) -> CGFloat {
        let rowType = indexPath.row
        switch cellType[rowType] {
        case "Gif":
            let currentNews = self.getCurrentNewsAtIndexSection(indexPath: indexPath)
            let localStruct = currentNews?.newsPart as! StrGif
            if localStruct.newsGif == "" {return 0} else { return 200}
        case "Link":
            let currentNews = self.getCurrentNewsAtIndexSection(indexPath: indexPath)
            let localStruct = currentNews?.newsPart as! StrLink
            if localStruct.url == "" {return 0} else { return UITableView.automaticDimension}
        case "IconUserTimeCell":
            return Constants.iconUserTimeHeight
        //коллекшн с фото
        case "PhotoCollectionCV":
            let currentNews = self.getCurrentNewsAtIndexSection(indexPath: indexPath)
            let localStruct = currentNews?.newsPart as! StrPhotoCollectionCV
            switch(localStruct.newsImages.count) {
            case 0:
                return 0
            default:
                return Constants.collectionViewInTableViewHeight
//                return UITableView.automaticDimension
              }
              
          default:
              return UITableView.automaticDimension
          }
      }//func getRowHeight
      
    
    /// функция запускает колесико refresh при дозагрузке свежих данных из Web
      func addRefreshControl(){
          customRefreshControl.attributedTitle = NSAttributedString(string:"refreshing...")
          customRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
          self.view?.addSubView(view: customRefreshControl)
      }
      
    
    /// функция дозагружает более свежие новости
      @objc func refreshTable(){
          
              self.isFetchingMoreNews = true
              self.vkAPI.getNewsList(token: Session.shared.token, userId: Session.shared.userId, nextFrom: nil, startTime: String(self.freshestDateInt + 1), version: Session.shared.version) { [weak self] result in
                     guard let self = self else { return }
                     switch result {
                     case .success(let posts):
                        if posts.items.count > 0 {
                          //сохраняем запрос, приводим к формату, разбиваем на секции, добавляем к текущему массиву и отображаем в TableView
                          self.workWithNewsWebQuery(responseNews: posts)
                        }//if posts.items.count > 0
                     case .failure(let error):
                         print(error)
                     }
                 }
               self.isFetchingMoreNews = false
              self.customRefreshControl.endRefreshing()

      } //@objc func refreshTable(){
}//class GroupPresenterImplementation

extension NewsViewPresenterImplementation {
    
    //MARK: функции для TableViewController с секциями
    func numberOfRowsInSection(section: Int) -> Int {
        let count = sortedNewsResults[section].items.count
        if count > cellType.count{
            print("задвоилось: count = \(count)")
        }
        return count
    }
    
    func getCurrentNewsAtIndexSection(indexPath: IndexPath) -> NewsWithSectionsAny? {
        return sortedNewsResults[indexPath.section].items[indexPath.row]
    }
    
    func numberOfSections() -> Int {
        return sortedNewsResults.count
    }
    
    func getSectionIndexTitles() -> [String]? {
        return sortedNewsResults.map{$0.title}
    }
    
    //функция реализует вызов перерисовки таблицы
    //по нажатию кнопки "показать полностью" в ячейке 
    func buttonClicked() {
        view?.updateTable()
    }
    
    //функция реализует вызов перерисовки таблицы
    //поcле определения состава фоток в ячейке с CollectionView
    func imageHeightDefined() {
         view?.updateTable()
    }
}// extension


