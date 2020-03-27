//
//  MessageViewConfigurator.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 01/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit


//protocol NewsViewConfigurator {
//    func configure( view: SolidNewsViewController)
//}
//
//class NewsViewConfiguratorImplementation: NewsViewConfigurator{
//    func configure( view: SolidNewsViewController) {
//        view.presenter = NewsViewPresenterImplementation (newsDB: NewsRepository(), view: view)
//    }
//}

//MARK: для нового контроллера новостей, с разделенными ячейками для новости
protocol NewMessageViewConfigurator {
    func configure( view: NewsViewController)
}

class NewMessageViewConfiguratorImplementation: NewMessageViewConfigurator{
    func configure( view: NewsViewController) {
        view.presenter = NewsViewPresenterImplementation (newsDB: NewsRepository(), view: view)
    }
}
