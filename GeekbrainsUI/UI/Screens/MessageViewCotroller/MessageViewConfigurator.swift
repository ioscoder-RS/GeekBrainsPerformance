//
//  MessageViewConfigurator.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 01/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

protocol MessageViewConfigurator {
    func configure(view: MessageViewController)
}

class MessageViewConfiguratorImplementation: MessageViewConfigurator{
    func configure( view: MessageViewController) {
       view.presenter = MessageViewPresenterImplementation (newsDB: NewsRepository(), view: view)
    }
}
