//
//  FirstScreen.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 04/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

protocol FirstScreenTune: class{
    func loginTune (userName:String)
}

class FirstScreen: UIViewController, FirstScreenTune {
    @IBOutlet weak var currentUser: UIButton!
    @IBOutlet weak var changeUser: UIButton!
    @IBOutlet weak var workOfflie: UIButton!
    @IBOutlet weak var cleanDatabase: UIButton!
 
    var presenter: FirstScreenPresenter?
    var configurator : FirstScreenConfigurator?
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        initUI()
     
        configurator?.configure(view: self)
        presenter?.viewDidLoad()
  
    }
    
    func initUI(){
        currentUser.setTitle("Войти в VK", for: .normal)
  //      changeUser.isHidden = true
        changeUser.setTitle("Cменить пользователя", for: .normal)
        workOfflie.setTitle("Работать через Firebase (БД офлайн)", for: .normal)
        cleanDatabase.setTitle("Очистить локальную БД", for: .normal)
    }
    
    @IBAction func currentUserPressed(_ sender: Any) {
        webMode = true //работаем с интернетом
        

        //загрузили контроллер для логина или попа
        transitionToLoginController(screenName: "VKLoginController")
        
    }
    
    @IBAction func changeUserPressed(_ sender: Any) {
        
    }
    
    @IBAction func workOfflinePressed(_ sender: Any) {
        webMode = false //работаем без интернета
        transitionToLoginController(screenName: "LocalLoginController")
    }
    
    @IBAction func cleanDatabasePressed(_ sender: Any) {
        let cr = CommonRepository()
        
        showYesNoMessage(view: self, title: "Внимание!", messagetext: "Вы действительно хотите удалить все данные из локальной БД!") { (result) in
            if result { //User has clicked on Ok
                cr.deleteAllRealmTables ()
            } else { //User has clicked on Cancel
                return
            }
        }
        
    }
    
    private func transitionToLoginController(screenName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: screenName)
        vc.modalPresentationStyle = .custom
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loginTune(userName:String){
        currentUser.setTitle("Войти как \(userName)", for: .normal)
    }
}//class FirstScreen: UIViewController
