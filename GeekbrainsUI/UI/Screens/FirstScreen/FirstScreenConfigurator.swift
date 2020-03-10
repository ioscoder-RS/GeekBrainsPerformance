//
//  FirstScreenConfigurator.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 20/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

protocol FirstScreenConfigurator {
    func configure(view: FirstScreen)
}

class FirstScreenConfiguratorImplementation: FirstScreenConfigurator{
    func configure (view: FirstScreen) {
        view.presenter = FirstScreenPresenterImplementation( view: view, loginDB: LoginRepository())
    }
    
}
