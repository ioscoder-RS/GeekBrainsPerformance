//
//  FriendsConfigurator.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 29/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

protocol FriendsConfigurator {
    func configure(view: FriendList)
}

class FriendsConfiguratorImplementation: FriendsConfigurator{
    func configure(view: FriendList) {
        view.presenter = FriendsPresenterImplementation(userDB: UserRepository(), photosDB: PhotoRepository() , view: view)
    }
}

//код инициализации конфигуратора
//ViewController.configurator = FriendsConfiguratorImplementation()
