//
//  FirstScreenPresenter.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 20/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//


import UIKit
import WebKit

protocol FirstScreenPresenter{
    func viewDidLoad ()
    func cleanDatabasePressed()
    func transitionToLoginController(screenName: String, navController: UINavigationController?)
}

class FirstScreenPresenterImplementation: NSObject, FirstScreenPresenter{
    
    private weak var view: FirstScreenTune?
    private var loginDB: LoginSource

    init (view: FirstScreen, loginDB: LoginSource) {
        
        self.view = view
        self.loginDB = loginDB
    }
    
    func viewDidLoad (){
        initUI()
    }

      func initUI(){
        //умолчательные значения кнопок
        view?.currentUser.setTitle("Войти в VK", for: .normal)
        view?.changeUser.setTitle("Cменить пользователя", for: .normal)
        view?.workOffline.setTitle("Работать через Firebase (БД офлайн)", for: .normal)
        view?.cleanDatabase.setTitle("Очистить локальную БД", for: .normal)
        
        //переименовываем кнопку логина если у нас есть сохраненный в БД логин
        var localLogin: VKUser?
        localLogin = self.getCurrentLoginFromDB()
        
        if localLogin != nil {
            var username: String
            username = localLogin!.firstName + " " + localLogin!.lastName
            //выводим имя пользователя на начальный экран
            loginTune(userName: username)
        } else {return}
      }
    
    func getCurrentLoginFromDB() -> VKUser? {
        return loginDB.getLogin()
    }//func getCurrentLogin()
    
  
    func loginTune(userName:String){
        view?.currentUser.setTitle("Войти как \(userName)", for: .normal)
    }
    
    func cleanDatabasePressed() {
        let cr = CommonRepository()
        
        showYesNoMessage(view: self.view as! UIViewController, title: "Внимание!", messagetext: "Вы действительно хотите удалить все данные из локальной БД!") { (result) in
            if result { //User has clicked on Ok
                cr.deleteAllRealmTables ()
            } else { //User has clicked on Cancel
                return
            }
        }
    }//func cleanDatabasePressed()
    
    func transitionToLoginController(screenName: String, navController: UINavigationController?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: screenName)
        vc.modalPresentationStyle = .custom
        navController?.pushViewController(vc, animated: true)
    }
}//class LoginPresenterImplementation


