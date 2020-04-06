//
//  PhotosConfigurator.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 04/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

protocol PhotosConfigurator {
    func configure(view: PhotoController, VKUserRealm: VKUserRealm)
}

class PhotosConfiguratorImplementation: PhotosConfigurator{
    func configure(view: PhotoController, VKUserRealm: VKUserRealm) {
//        view.presenter = PhotosPresenterImplementation(database: PhotoRepository(),
//                                                        view: view,
//                                                       VKUserRealm:  VKUserRealm)
    }
}
