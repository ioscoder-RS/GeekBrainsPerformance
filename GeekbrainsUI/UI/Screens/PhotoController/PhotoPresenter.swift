//
//  PhotoPresenter.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 04/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import RealmSwift

protocol PhotosPresenter{
    func viewDidLoad()
    func getVKPhotosRealmAtIndex(indexPath: IndexPath) -> VKPhotosRealm?
}

class PhotosPresenterImplementation: PhotosPresenter {
    
    private var vkAPI: VKAPi
    private var database: PhotosRepositorySource
    private var localVKUserRealm: VKUserRealm
    
    private var photosResult: Results<VKPhotosRealm>!
    private weak var view: PhotoController?
    
    
    init (database: PhotosRepositorySource, view: PhotoListView, VKUserRealm: VKUserRealm) {
        vkAPI = VKAPi()
        self.database = database
        self.localVKUserRealm = VKUserRealm
        
        do
        {
            self.photosResult = try database.getAllPhotos()
        }catch { print(error)}
    }
    
    func viewDidLoad() {
    }
}//class PhotosPresenterImplementation

extension PhotosPresenterImplementation {
    func getVKPhotosRealmAtIndex(indexPath: IndexPath) -> VKPhotosRealm? {
        return photosResult[indexPath.row]
    }
}
