//
//  ViewController.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 23/11/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit
import Alamofire
import WebKit
import FirebaseAuth
import FirebaseDatabase


class LoginViewController: UIViewController, UITextFieldDelegate //для фокусирования курсора на текстовое поле
{
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var Login2: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //для функции анимации на лого
    var propertyAnimator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 1.0, dampingRatio: 1.0, animations:{})
    
    var vkAPI = VKAPi()
    private var users = [UserFirebase]()
    
    private var login: String?
    private var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let HideAction = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(HideAction)
    }
    
    //функция, убирающая клавиатуру с экрана при нажатии вне текстового поля
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
            
    @IBAction func RegPressed(_ sender: Any) {

        
        if !self.readAuthData() {return}
        //MARK: код создания нового пользователя в FireBase
        Auth.auth().createUser(withEmail: login!, password: password!){
            (result,error) in
            if result != nil {
                self.showLoginError(title:"Поздравляем!", messagetext: "Успешно зарегистрирован пользователь: \(String( result!.user.email!))")
            } else{
                print(error as Any)
            }
        }
    }
    
    @IBAction func nextWindow(_ sender: Any) {
        
        // MARK: FireBase Sign in сущ-го пользователя
        
        if !readAuthData() {return}
        Auth.auth().signIn(withEmail: login!, password: password!){
            (result, error) in
            if let id = result?.user.uid{
                print(id)
                
                //go to tabbar
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "MainTab")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                self.showLoginError(title:"Ошибка", messagetext: "Что-то пошло не так: \(String(describing: error))")
            }
        }
    }
    
    
    func checkLogin()-> Bool {
        guard let loginInput = Login2.text, let passwordInput = Password.text else {return false}
        
        if (loginInput == "")||(passwordInput == "") {
            return false
        } else{
            return true
        }
    }//func
    
    func showLoginError(title: String, messagetext: String){
        //добавляем обработку ошибок
        
        // Создаем контроллер
        let alert = UIAlertController(title: title, message: messagetext, preferredStyle: .alert)
        // Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            self.Login2.becomeFirstResponder()}) //в handler добавили текстовое поле, чтобы на него сфокусироваться
        // Добавляем кнопку на UIAlertController
        alert.addAction(action)
        // Показываем UIAlertController
        present(alert, animated: true, completion: nil)
    }
    
   private func readAuthData() -> Bool {
       
          let checkResult = checkLogin()
          if !checkResult {
            showLoginError(title:"Ошибка", messagetext: "Авторизуйтесь для работы с приложением")
           return false
       }
      
       login = Login2.text!
       password = Password.text!
       return true
   }
   
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
      return readAuthData()
    }
    
    func modifyFireBase(){
    
        let ref = Database.database().reference(withPath: "users")
        ref.observe(.value) { (snapshot) in
            for node in snapshot.children {
                if let object = node as? DataSnapshot {
                    print(object.value!)
                    
                    if let user = UserFirebase(snapshot: object){
                        self.users.append(user)
                    }
                }
            }
        }
    }// func modifyFireBase
    
}//class




