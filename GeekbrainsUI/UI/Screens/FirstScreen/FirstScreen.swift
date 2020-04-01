//
//  FirstScreen.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 04/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

protocol FirstScreenTune: class{
    var currentUser: UIButton! { get set }
    var changeUser: UIButton!  { get set }
    var workOffline: UIButton! { get set }
    var cleanDatabase: UIButton! { get set }
    var isNewUser: Bool { get set }
}

class FirstScreen: UIViewController, FirstScreenTune {
    @IBOutlet weak var currentUser: UIButton!
    @IBOutlet weak var changeUser: UIButton!
    @IBOutlet weak var workOffline: UIButton!
    @IBOutlet weak var cleanDatabase: UIButton!
 
    var presenter: FirstScreenPresenter?
    var configurator : FirstScreenConfigurator?
    var isNewUser: Bool = false
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        self.configurator = FirstScreenConfiguratorImplementation()
        configurator?.configure(view: self)
        presenter?.viewDidLoad()
  
    }
        
    @IBAction func currentUserPressed(_ sender: Any) {
        webMode = true //работаем с интернетом
        
        //загрузили контроллер для логина или попа
        presenter?.transitionToVKLoginController(navController: self.navigationController, isNewUser: self.isNewUser)
        
    }
    
    @IBAction func changeUserPressed(_ sender: Any) {
        self.isNewUser = true
        presenter?.changeUserPressed()
    }
    
    @IBAction func workOfflinePressed(_ sender: Any) {
        webMode = false //работаем без интернета
        presenter?.transitionToLoginController(screenName: "LocalLoginController", navController: self.navigationController)
    }
    
    @IBAction func cleanDatabasePressed(_ sender: Any) {
        presenter?.cleanDatabasePressed()
    }
    

    
}//class FirstScreen: UIViewController
