//
//  CoreDataManager.swift
//  Course2FinalTask
//
//  Created by Polina on 16.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataManager {
    static let shared = CoreDataManager(modelName: "Model")
}

final class CoreDataManager {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    func save(context: NSManagedObjectContext) {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = context
        guard context.hasChanges else { return }
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func save() {
        if getContext().hasChanges {
            do {
                try getContext().save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createObject<T: NSManagedObject> (from entity: T.Type) -> T {
        let context = getContext()
        let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: entity),
                                                         into: context) as! T
        return object
    }
    
    func delete(object: NSManagedObject) {
        let context = getContext()
        context.delete(object)
        save(context: context)
    }
    
    func getUserEntity<T: NSManagedObject>(userid: String) -> [T] {
        let idPredicate = NSPredicate(format: "author == '\(userid)'")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate])
        let sortDescriptor = NSSortDescriptor(key: "createdTime", ascending: false)
        
        let resultArray = fetchData(for: T.self, predicate: compoundPredicate, sortDescriptor: sortDescriptor)
        
        let result: [T]
        
        if resultArray.isEmpty {
            result = []
        } else {
            result = resultArray
        }
        return result
    }
    
    func fetchData<T: NSManagedObject>(for entity: T.Type, predicate: NSCompoundPredicate? = nil, sortDescriptor: NSSortDescriptor? = nil) -> [T] {
        
        let context = getContext()
        let request: NSFetchRequest<T>
        var fetchResult = [T]()
        
        if #available(iOS 10.0, *) {
            request = entity.fetchRequest() as! NSFetchRequest<T>
        } else {
            request = NSFetchRequest(entityName: String(describing: entity))
        }
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        if let sortDescriptor = sortDescriptor {
            request.sortDescriptors = [sortDescriptor]
        }
        
        do {
            fetchResult = try context.fetch(request)
        } catch {
            debugPrint("no fetch: \(error.localizedDescription)")
        }
        
        return fetchResult
    }
}
