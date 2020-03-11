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

enum DatabaseType {
    case Realm
    case CoreData
}

 typealias Out = Swift.Result

 var databaseMode = true //флаг пишем ли в БД или только с Web работаем
 var webMode = false //флаг работаем офлайн или с обращением к интернету



