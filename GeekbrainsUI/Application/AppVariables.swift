//
//  CommonResponse.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 24/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import Foundation
import UIKit

let debugMode = 0 //1 - debug on, 0 - debug off
let debugPrefetchMode = true //true - печатает лог, falsе -  не печатает

enum DatabaseType {
    case Realm
    case CoreData
}

 typealias Out = Swift.Result

 var databaseMode = true //флаг пишем ли в БД или только с Web работаем
 var webMode = false //флаг работаем офлайн или с обращением к интернету

//extension Date {
//    var millisecondsSince1970:Int64 {
//        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
//    }
//
//    init(milliseconds:Int64) {
//        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
//    }
//}

struct Section<T>{
    var title: String
    var items: [T]
}
