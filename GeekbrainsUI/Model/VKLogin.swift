//
//  VKLogin.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 19/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import Foundation

// MARK: - Последний = текущий логин


var webVKLogin = [VKUser]()

struct LoginResponse: Codable {
    let response: [VKUser]
}


