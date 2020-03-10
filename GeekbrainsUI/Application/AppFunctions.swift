//
//  AppFunctions.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 06/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

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
