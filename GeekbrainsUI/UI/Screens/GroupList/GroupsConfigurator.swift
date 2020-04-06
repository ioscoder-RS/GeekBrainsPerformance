//
//  GroupsConfigurator.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 06/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

protocol GroupsConfigurator {
    func configure(view: GroupList)
}

class GroupsConfiguratorImplementation: GroupsConfigurator{
    func configure( view: GroupList) {
        view.presenter = GroupPresenterImplementation (groupDB: GroupRepository(), view: view)
    }
}
