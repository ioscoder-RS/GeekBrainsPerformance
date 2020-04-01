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
    func changeUserPressed()
    func transitionToLoginController(screenName: String, navController: UINavigationController?)
    func transitionToVKLoginController(navController: UINavigationController?, isNewUser:Bool)
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
        view?.currentUser.setTitle("Войти в ВК", for: .normal)
        view?.changeUser.setTitle("Сменить пользователя", for: .normal)
        view?.workOffline.setTitle("Войти через Firebase (работать оффлайн)", for: .normal)
        view?.cleanDatabase.setTitle("Очистить локальную БД", for: .normal)
        
        //переименовываем кнопку логина если у нас есть сохраненный в БД логин
        var localLogin: VKUser?
        localLogin = self.getCurrentLoginFromDB()
        
        if localLogin != nil {
            var username: String
            username = localLogin!.fullName
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
        
        let localizedTitle = NSLocalizedString("Внимание", comment: "")
        let messageText = NSLocalizedString("Вы действительно хотите очистить локальную БД ?!", comment: "текст предупреждения об удалении локальной БД Realm")
        
        showYesNoMessage(view: self.view as! UIViewController, title: localizedTitle, messagetext: messageText ) { (result) in
            if result { //User has clicked on Ok
                cr.deleteAllRealmTables ()
               
            } else { //User has clicked on Cancel
                return
            }
        }
    }//func cleanDatabasePressed()
    
    func changeUserPressed() {
 
        showYesNoMessage(view: self.view as! UIViewController, title: "Внимание", messagetext: "Вы действительно хотите удалить текущего пользователя?") { (result) in
            if result { //User has clicked on Ok
                self.loginDB.clearLogin()
                self.view?.currentUser.setTitle("Войти в VK", for: .normal)
                self.view?.isNewUser = true
            } else { //User has clicked on Cancel
                self.view?.isNewUser = false
                return
            }
        }
    }//    func changeUserPressed()
    
    func transitionToVKLoginController(navController: UINavigationController?, isNewUser:Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "VKLoginController" ) as VKLoginController? else {return}
        vc.modalPresentationStyle = .custom
        vc.isNewUser = isNewUser
        navController?.pushViewController(vc, animated: true)
            return

    }
    
    func transitionToLoginController(screenName: String, navController: UINavigationController?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: screenName)
        vc.modalPresentationStyle = .custom

        navController?.pushViewController(vc, animated: true)
            return

    }
}//class LoginPresenterImplementation


