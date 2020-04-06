//
//  Singleton.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 15/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import WebKit

class Session {
    static let shared = Session()
    private init () {}
    
    var token = ""
    var userId = "0"
    var webView = WKWebView()
    var version = ""
    var appVersion = 0.0
}
