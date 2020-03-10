//
//  LoginPresenter.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 19/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit
import WebKit

protocol LoginPresenter{
    func transitionToTabBar()
    func getLoginFromWebAndSave()
}

class LoginPresenterImplementation: NSObject, LoginPresenter{
     private weak var view: VKLoginController? // экран логина в VK
   
    private var mainTab = MainTab()
    
    private var loginDB: LoginSource
    private let vkSecret = "7281379"
    
    private var vkAPI: VKAPi
    var currentLogin: VKLogin?
    
    init (view: VKLoginController, loginDB: LoginSource) {
       
        self.view = view
        self.loginDB = loginDB
   vkAPI = VKAPi()
    }
    
    func transitionToTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MainTab")
        vc.modalPresentationStyle = .custom
        self.view?.navigationController?.pushViewController(vc, animated: true)
    }// func transitionToTabBar()
    
  func getLoginFromWebAndSave(){
        //получаем параметры логина из SingleTon
        let token = Session.shared.token
        let id = Session.shared.userId
        
        //Получаем логин из Web
        getCurrentLoginFromWeb(token: token, id: id){
        result in
          switch result  {
          case .success(let vkLogin):
            
            //сохраняем полученный логин в БД
            self.saveLoginToDB(oneLogin: vkLogin)
                
            //сохраняем логин в MainTab
            self.mainTab.vkLogin = vkLogin
            
          case .failure(_):
            return
        }//switch
        }//completion getCurrentLoginFromWeb
    }//func getLoginFromWebAndSave()
    
    func getCurrentLoginFromWeb(token:String, id: String, completion: @escaping (Out<VKLogin,Error>)-> Void){
        
        vkAPI.getLogin(token: token, loginId: id ){  result in
            switch result {
            case .success(let webLogin): //логин VKLogin из Web в виде массива
                let localLogin = webLogin.first!
                print("Успешно получен логин: \(localLogin.id)")
                completion(.success(localLogin))

            case .failure(let error):
                print("we got error in vkAPI.getLogin(): \(error)")
                completion(.failure(error))
            }//switch
        }//completion
    }
    

    

    
    func saveLoginToDB(oneLogin: VKLogin){
        do{
             try self.loginDB.addLogin(login: oneLogin)
             print("Успешно сохранен логин: \(oneLogin.id) \(oneLogin.firstName)")
         }catch {
             print("we got error in database.getLogin(): \(error)")
         }
    }
    
}//class LoginPresenterImplementation

