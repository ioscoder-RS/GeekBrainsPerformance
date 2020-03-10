//
//  CoreData.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 21/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private let storeContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init(){
        storeContainer = NSPersistentContainer(name: "VKDatabase")
        storeContainer.loadPersistentStores {( _, error) in
        }
        context = storeContainer.viewContext
    }
}//class CoreDataStack
