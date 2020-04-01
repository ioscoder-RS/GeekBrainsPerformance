//
//  AppFunctions.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 06/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit
import WebKit

func showYesNoMessage(view: UIViewController, title: String, messagetext: String, completion:@escaping (_ result:Bool) -> Void) {

    // Создаем контроллер
    let alert = UIAlertController(title: title, message: messagetext, preferredStyle: .alert)
    // Создаем кнопку для UIAlertController
    let action = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
        completion(false)
    })
     alert.addAction(action)
    
    let action2 = UIAlertAction(title: "Delete", style: .destructive, handler: {action in
        completion(true)
        
    })
    alert.addAction(action2)
    // Показываем UIAlertController
    view.present(alert, animated: true, completion: nil )
    
}// func showYesNoMessage




/// калькулятор форматов: https://nsdateformatter.com

func convertUnixTime(unixTime:Int)-> String {
    //функция конвертации UNIX-даты
      let unixTimestamp = unixTime
      let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
      
      let dateFormatter = DateFormatter()
      
      dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
      dateFormatter.locale = Locale(identifier: "ru_RU")
      dateFormatter.dateFormat = "EEEE, HH:mm" //Specify your format that you want
     return (dateFormatter.string(from: date))
}

func viewableUnixTime(unixTime:Int) -> String {
    
    let unixTimestamp = unixTime
    let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    //отсчитываем 6 дней назад от текущей даты
    let before = Date().addingTimeInterval(-(60*60*24*6))
    
    timeFormatter.dateFormat = "HH:mm"
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    dateFormatter.locale = Locale(identifier: "ru_RU")
    
    if Calendar.current.isDateInToday(date) {
        
        return "сегодня в \(timeFormatter.string(from: date))"
    }
    else if Calendar.current.isDateInYesterday(date) {
        return "вчера в \(timeFormatter.string(from: date))"
    }
    else if date > before {
        dateFormatter.dateFormat = "EEEE"
        return "\(dateFormatter.string(from: date)) в \(timeFormatter.string(from: date))"
    }
    else {
        dateFormatter.dateFormat = "d MMMM"
        return "\(dateFormatter.string(from: date)) \(timeFormatter.string(from: date))"
    }
}

extension String {
    func getHeight(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return ceil(label.frame.height)
    }
}


extension UIViewController {
    func showAlert(error: Error) {
        let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}


extension WKWebView {

    private var httpCookieStore: WKHTTPCookieStore  { return WKWebsiteDataStore.default().httpCookieStore }

    func getCookies(for domain: String? = nil, completion: @escaping ([String : Any])->())  {
        var cookieDict = [String : AnyObject]()
        httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                if let domain = domain {
                    if cookie.domain.contains(domain) {
                        cookieDict[cookie.name] = cookie.properties as AnyObject?
                    }
                } else {
                    cookieDict[cookie.name] = cookie.properties as AnyObject?
                }
            }
            completion(cookieDict)
        }
    }
}
