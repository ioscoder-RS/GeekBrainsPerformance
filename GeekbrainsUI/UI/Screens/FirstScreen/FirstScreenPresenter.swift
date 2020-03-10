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
}

class FirstScreenPresenterImplementation: NSObject, FirstScreenPresenter{
    
    private weak var view: FirstScreenTune?
    private var loginDB: LoginSource

    init (view: FirstScreen, loginDB: LoginSource) {
        
        self.view = view
        self.loginDB = loginDB
    }
    
    func viewDidLoad (){
        var localLogin: VKLogin?
        localLogin = self.getCurrentLoginFromDB()
        
        if localLogin != nil {
            var username: String
            username = localLogin!.firstName + " " + localLogin!.lastName
            //выводим имя пользователя на начальный экран
            view?.loginTune(userName: username)
        } else {return}

    }

    func getCurrentLoginFromDB() -> VKLogin? {
        return loginDB.getLogin()
    }//func getCurrentLogin()
    
  
    
}//class LoginPresenterImplementation


