//
//  AppDelegate.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 23/11/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

 var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        setRealmConfig(version: 7)
 
        FirebaseApp.configure()
        
       return true
        
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func setRealmConfig(version: UInt64) {
        let config = Realm.Configuration(
                   // Set the new schema version. This must be greater than the previously used
                   // version (if you've never set a schema version before, the version is 0).
                schemaVersion: version,
                   // Set the block which will be called automatically when opening a Realm with
                   // a schema version lower than the one set above
                   migrationBlock: { migration, oldSchemaVersion in
                       // We haven’t migrated anything yet, so oldSchemaVersion == 0
                       if (oldSchemaVersion < 1) {
                           // Nothing to do!
                           // Realm will automatically detect new properties and removed properties
                           // And will update the schema on disk automatically
                       }
               })
                 Realm.Configuration.defaultConfiguration = config
        
        print(config.fileURL!)
    }

}

