//
//  VKService.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 19/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import Foundation

class VKService {
    
    var request: URLRequest? = nil
    private let apiVersion = "5.103"
    private let baseUrl = "https://api.vk.com"
    private let VKSecret = "7281379"
    private let scope = "336918"
    
    init() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: VKSecret),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: apiVersion)
        ]
        
        self.request = URLRequest(url: urlComponents.url!)
    }

}

