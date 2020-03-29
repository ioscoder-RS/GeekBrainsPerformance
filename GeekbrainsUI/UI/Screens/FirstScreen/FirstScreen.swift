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
    
}

class FirstScreen: UIViewController, FirstScreenTune {
    @IBOutlet weak var currentUser: UIButton!
    @IBOutlet weak var changeUser: UIButton!
    @IBOutlet weak var workOffline: UIButton!
    @IBOutlet weak var cleanDatabase: UIButton!
 
    var presenter: FirstScreenPresenter?
    var configurator : FirstScreenConfigurator?
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        self.configurator = FirstScreenConfiguratorImplementation()
        configurator?.configure(view: self)
        presenter?.viewDidLoad()
  
    }
        
    @IBAction func currentUserPressed(_ sender: Any) {
        webMode = true //работаем с интернетом
        
        //загрузили контроллер для логина или попа
        presenter?.transitionToLoginController(screenName: "VKLoginController", navController: self.navigationController)
        
    }
    
    @IBAction func changeUserPressed(_ sender: Any) {
        
    }
    
    @IBAction func workOfflinePressed(_ sender: Any) {
        webMode = false //работаем без интернета
        presenter?.transitionToLoginController(screenName: "LocalLoginController", navController: self.navigationController)
    }
    
    @IBAction func cleanDatabasePressed(_ sender: Any) {
        presenter?.cleanDatabasePressed()
    }
    
//    private func transitionToLoginController(screenName: String) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: screenName)
//        vc.modalPresentationStyle = .custom
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
}//class FirstScreen: UIViewController
