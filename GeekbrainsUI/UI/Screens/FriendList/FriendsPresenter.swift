//
//  FriendsPresenter.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 29/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import Foundation
import RealmSwift

protocol FriendsPresenter{
    //   typealias Out = Swift.Result
    
    func viewDidLoad()
    func searchFriends(name: String)
    func getPhotosByVKUserRealmAndGo(view: FriendList, userRealm: VKUserRealm)
    
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func getSectionIndexTitles() -> [String]?
    func getVKUserRealmAtIndex(indexPath: IndexPath) -> VKUserRealm?
    func getTitleForSection(section: Int) -> String?
    
    func getPhotoControllerCount() -> Int
    func getVKPhotoAtIndex(indexPath: IndexPath) -> VKPhotosRealm?
    func getVKPhotoSizesAtIndex(indexPath: IndexPath) -> List<PhotoSizesRealm>?
    func getVKPhotoLikesAtIndex(indexPath: IndexPath) -> PhotoLikesRealm?
}

struct SectionRealm<T: RealmCollectionValue>{
    var title: String
    var items: Results<T>
}

class FriendsPresenterImplementation : FriendsPresenter {
    var friends = [Friend]()
    
    private var vkAPI: VKAPi
    private var userDB: FriendsSource
    private var photosDB: PhotosRepositorySource
    
    //mvc
    private var sortedFriendsResults = [Section<VKUserRealm>]()
    private var friendsResult: Results<VKUserRealm>!
    
    private var photosResult: Results<VKPhotosRealm>!
    
    private weak var view:FriendsListView?
    
    init (userDB: FriendsSource, photosDB: PhotosRepositorySource, view: FriendsListView) {
        vkAPI = VKAPi()
        self.userDB = userDB
        self.photosDB = photosDB
        self.view = view
    }
    
    func viewDidLoad() {
        
        getFriendsFromApiAndDB()
    }
    
    func getFriendsFromDatabase(){
        do {
            self.friendsResult = try userDB.getAllUsers()
            self.makeSortedSections()
            self.view?.updateTable()
        }catch { print(error)}
    }//func getFriendsFromDatabase()
    
    
    func getFriendsFromApiAndDB(){
        
        if webMode{
        //Получаем пользователей из Web
        vkAPI.getFriendList(token: Session.shared.token){  result in
            switch result {
            case .success(let webUsers): //массив VKUser из Web
                do{
                    try self.userDB.addUsers(users: webUsers)
                    //выгружаем из БД строго после Web-запроса и после добавления в БД
                    self.getFriendsFromDatabase()
                }catch {
                    print("we got error in database.getAllUsers(): \(error)")
                }
            case .failure(let error):
                print("we got error in getFriendsFromApi(): \(error)")
            }//switch
        }//completion
        }// if webMode{
        else
        {
        self.getFriendsFromDatabase()
        }
        
    }//func getFriendsFromApi()
    
    func searchFriends(name: String) {
        do {
            self.friendsResult = name.isEmpty ? try userDB.getAllUsers() : try userDB.searchUsers(name: name)
            makeSortedSections()
            self.view?.updateTable()
        }catch {
            print(error)
        }
    }
    
    func getPhotosFromDatabase(userID: Int){
        do {
            self.photosResult = try photosDB.getPhotosByUser(userID: userID)
        }catch { print("Ошибка в функции getPhotosFromDatabase: \(error)")}
    }
    
    func getPhotosByVKUserRealmAndGo(view: FriendList, userRealm: VKUserRealm) {
 
        if webMode{
            vkAPI.getPhotosList(token: Session.shared.token, userId: userRealm.id){  result in
                switch result {
                case .success(let photos):
                    //сохраняем фото в БД
                    self.photosDB.addPhotos(photos: photos)
                    //извлекаем из БД
                    do{
                        try self.photosResult = self.photosDB.getPhotosByUser(userID: userRealm.id)
                    }catch {print("we got error in photosDB.getPhotosByUser(): \(error)")}
                    
                    //вызываем след. ViewController
                    self.moveToNextViewController(view: view, userRealm: userRealm)
                    
                case .failure(let error):
                    print("we got error in vkAPI.getPhotosList: \(error)")
                }//switch case
            }//completion
        }//if webMode
        else{
                //берем данные только из БД
            do{
                try self.photosResult = self.photosDB.getPhotosByUser(userID: userRealm.id)
            }catch {
                print("we got error in photosDB.getPhotosByUser(): \(error)")
            }
            //вызываем след. ViewController
            self.moveToNextViewController(view: view, userRealm: userRealm)
        }//else if webMode
    }
    
    func moveToNextViewController(view: FriendList, userRealm: VKUserRealm ){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let viewController = storyboard.instantiateViewController(identifier: "PhotoController") as! PhotoController
        
        viewController.tmpFriend = convertFriend(user:userRealm.toModel())
          viewController.tmpVKUserRealm = userRealm
          //           viewController.photoArray = photos
          //viewController.configurator = config
          viewController.presenter = self
          view.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func makeSortedSections(){
        let groupedFriends = Dictionary.init(grouping: friendsResult){$0.lastName.prefix(1) }
        sortedFriendsResults = groupedFriends.map { Section(title: String($0.key), items: $0.value) }
        sortedFriendsResults.sort {$0.title < $1.title}
    }// func makeSortedSections()
    
}//class

extension FriendsPresenterImplementation {
    func numberOfRowsInSection(section: Int) -> Int {
        return sortedFriendsResults[section].items.count
    }
    
    func getVKUserRealmAtIndex(indexPath: IndexPath) -> VKUserRealm? {
        return sortedFriendsResults[indexPath.section].items[indexPath.row]
    }
    
    func numberOfSections() -> Int {
        return sortedFriendsResults.count
    }
    
    func getSectionIndexTitles() -> [String]? {
        return sortedFriendsResults.map{$0.title}
    }
    
    func getTitleForSection(section: Int) -> String? {
        return sortedFriendsResults[section].title
    }
    
    func getPhotoControllerCount() -> Int {
        return photosResult.count
    }
    
    func getVKPhotoAtIndex(indexPath: IndexPath) -> VKPhotosRealm? {
        return photosResult[indexPath.row]
    }
    
    func getVKPhotoSizesAtIndex(indexPath: IndexPath) -> List<PhotoSizesRealm>? {
        return photosResult[indexPath.row].sizes
    }
    
    func getVKPhotoLikesAtIndex(indexPath: IndexPath) -> PhotoLikesRealm? {
        return photosResult[indexPath.row].likes
    }
}

