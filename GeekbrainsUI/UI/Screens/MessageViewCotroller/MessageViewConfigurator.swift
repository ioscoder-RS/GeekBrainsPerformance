//
//  MessageViewConfigurator.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 01/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

enum viewControllers{
    case SolidNewsViewController
    case FlexNewsViewController
}

protocol MessageViewConfigurator {
    func configure( view: SolidNewsViewController)
}

class MessageViewConfiguratorImplementation: MessageViewConfigurator{
    func configure( view: SolidNewsViewController) {
        view.presenter = MessageViewPresenterImplementation (newsDB: NewsRepository(), view: view)
    }
}

//MARK: для нового контроллера новостей, с разделенными ячейками для новости
protocol NewMessageViewConfigurator {
    func configure( view: FlexNewsViewController)
}

class NewMessageViewConfiguratorImplementation: NewMessageViewConfigurator{
    func configure( view: FlexNewsViewController) {
        view.presenter = MessageViewPresenterImplementation (newsDB: NewsRepository(), view: view)
    }
}
