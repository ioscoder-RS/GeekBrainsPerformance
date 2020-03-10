//
//  LoginConfigurator.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 19/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import Foundation

protocol LoginConfigurator {
    func configure(view: VKLoginController)
}

class LoginConfiguratorImplementation: LoginConfigurator{
    func configure(view: VKLoginController) {
    view.presenter = LoginPresenterImplementation( view: view, loginDB:  LoginRepository())
    }
    
}
