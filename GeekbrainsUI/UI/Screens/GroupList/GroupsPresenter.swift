//
//  GroupsPresenter.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 29/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import Foundation
import RealmSwift

protocol GroupsPresenter {
    func viewDidLoad()
    func searchGroups(name: String)
    
    func numberOfRows() -> Int
    func getVKGroupRealmAtIndex(indexPath: IndexPath) -> VKGroupRealm? 
}

class GroupPresenterImplementation: GroupsPresenter {
    private var vkAPI: VKAPi
    private weak var view: GroupListView?
    var groupRepository = GroupRepository()
    var groupsResult: Results<VKGroupRealm>!
    var token: NotificationToken?
    var tokenUser: NotificationToken?
    
    private var groupDB: GroupsSource
    
    init (groupDB: GroupsSource, view: GroupListView){
        self.view = view
        self.groupDB = groupDB
        vkAPI = VKAPi()
    }
    
    deinit {
        token?.invalidate()
    }
    
    func viewDidLoad(){
        getGroupsFromApiAndDB()
    }
    
    func getGroupsFromDatabase(){
        do {
            self.groupsResult = try groupDB.getAllGroups()
            self.view?.updateTable()
            setupObserver()
        }catch
        { print(error)}
    }//func getGroupsFromDatabase()
    
    func  getGroupsFromApiAndDB(){
        if webMode{
        //Получаем пользователей из Web
            vkAPI.getGroupsList(token: Session.shared.token, userId: Session.shared.userId){  result in
            switch result {
            case .success(let webGroups): //массив VKGroup из Web
                do{
                    try self.groupDB.addGroups(groups: webGroups)
                    //выгружаем из БД строго после Web-запроса и после добавления в БД
                    self.getGroupsFromDatabase()
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
        self.getGroupsFromDatabase()
        }
    }//func  getGroupsFromApiAndDB()
    
    func searchGroups(name: String) {
        do {
            self.groupsResult = name.isEmpty ? try groupDB.getAllGroups() : try groupDB.searchGroups(name: name)
       
            self.view?.updateTable()
        }catch {
            print(error)
        }
    }
    
    func setupObserver() {
        //MARK: отслеживание изменений в БД
        token = groupsResult.observe {[weak self] results in
            switch results{
            case .error(let error):
                print(error)
            case .initial(_):
                self?.view?.updateTable()
            case let .update(_,  deletions, insertions,  modifications):
                self?.view?.updateForObserver(deletions: deletions, insertions: insertions, modifications: modifications)
            }// switch results
        }//completion
    }//func setupObserver()

}//class GroupPresenterImplementation

extension GroupPresenterImplementation {
    func numberOfRows() -> Int {
        return groupsResult?.count ?? 0
    }
    func getVKGroupRealmAtIndex(indexPath: IndexPath) -> VKGroupRealm? {
          return groupsResult[indexPath.row]
      }
}


