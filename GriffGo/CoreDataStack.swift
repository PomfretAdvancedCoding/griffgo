//
//  CoreDataStack.swift
//  Checklists
//
//  Created by Tim Baldyga on 12/12/16.
//  Copyright © 2016 Tim Baldyga. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static var shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Checklists")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            print("Location: \(storeDescription.url)")
            if let error = error {
                fatalError("CoreData error: \(error)")
            }
        })
        
        return container
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    func saveContext() {
        let context = managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed while saving: \(error)")
            }
        }
    }
}
