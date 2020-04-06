//
//  PhotoRepository.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 29/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import RealmSwift

protocol PhotosRepositorySource: class {
    func getAllPhotos() throws -> Results<VKPhotosRealm>
    func getPhotosByUser(userID: Int) throws -> Results<VKPhotosRealm>
    func addPhotos (photos:[VKPhoto])    
}

class PhotoRepository: PhotosRepositorySource {
    
    var localCommonRepository = CommonRepository()
    
    func getAllPhotos() throws -> Results<VKPhotosRealm>{
        let realm = try Realm()
        do {
            return try realm.objects(VKPhotosRealm.self) as Results <VKPhotosRealm>
            // return try (localCommonRepository.getAllfromTable(vkObject: .VKPhoto) as? Results<VKPhotosRealm>)!
        } catch {
            throw error
        }
    }//func getAllPhotos
    
    func getPhotosByUser(userID: Int) throws -> Results<VKPhotosRealm>{
        let realm = try Realm()
        do {
            return try realm.objects(VKPhotosRealm.self).filter("ownerID == %@", userID) as Results <VKPhotosRealm>
        } catch {
            throw error
        }
    }//func PhotosByUser
    
    func addPhotos (photos:[VKPhoto]) {
        do {
            let realm = try! Realm()
            try realm.write {
                var photosToAdd = [VKPhotosRealm]()
                photos.forEach{
                    photo in
                    let photosRealm = VKPhotosRealm()
                    
                    photosRealm.id = photo.id
                    photosRealm.likes = photo.likes.map{ $0.toRealm()}
                    photosRealm.sizes.append(objectsIn: photo.sizes.map{ $0.toRealm() })
                    photosRealm.albumID = photo.albumID
                    photosRealm.ownerID = photo.ownerID
                    photosRealm.text = photo.text
                    photosToAdd.append(photosRealm)
                }//groups.forEach
                
                realm.add(photosToAdd, update: .modified)
            }//realm.write
       //     print(realm.objects(VKPhotosRealm.self))
        }catch{
            print(error)
        }
    }// func addGroups
    
}//class class GroupRepository
