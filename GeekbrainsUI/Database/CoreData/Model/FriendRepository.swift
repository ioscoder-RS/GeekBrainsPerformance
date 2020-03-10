//
//  FriendRepository.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 24/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//


import CoreData

protocol Repository {
    associatedtype Entity
    
    func getAll() -> [Entity]
    func get(id:Int) -> Entity?
}

class FriendCoreDataRepository: Repository {
    typealias Entity = VKUser
    
    let context: NSManagedObjectContext
    
    init(stack: CoreDataStack){
        self.context = stack.context
    }
    
    private func queryCD(with predicate: NSPredicate?, sortDescriptors:[NSSortDescriptor]?=nil)->[FriendCD]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendCD")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do{
            return try (context.fetch(fetchRequest) as? [FriendCD] ?? [])
        }catch{
            return []
        }
    }//private func queryCD
    
    private func query(with predicate: NSPredicate?, sortDescriptors:[NSSortDescriptor]?=nil)->[VKUser]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendCD")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do{
            let objects = try (context.fetch(fetchRequest)) as? [FriendCD]
            return objects?.map{$0.toCommonItem() } ?? []
        }catch{
            print(error)
            return []
        }
    }//private func query
    
    func getAll() -> [VKUser]{
        return query(with: nil, sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)])
    }
    
    func get(id: Int) -> VKUser? {
        return query(with: NSPredicate(format: "id = %@","\(id)" )).first
    }
    
    func create(entity: VKUser) -> Bool {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "FriendCD", in: context) else {
            return false
        }
        
        if get(id: entity.id) != nil {
            return false
        }
        
        let friendEntity = NSManagedObject(entity: entityDescription, insertInto: context)
        friendEntity.setValue(entity.id, forKey: "id")
        friendEntity.setValue(entity.avatarPath, forKey: "avatarPath")
        //friendEntity.setValue(entity.deactivated, forKey: "deactivated")
        friendEntity.setValue(entity.firstName, forKey: "firstName")
        friendEntity.setValue(entity.lastName, forKey: "lastName")
        friendEntity.setValue(entity.isOnline, forKey: "isOnline")
        return save()
    }//func create
    
    private func save() -> Bool{
        do {
            try context.save()
            return true
        }catch{
            print(error)
            return false
        }
    }
}//class FriendRepository
