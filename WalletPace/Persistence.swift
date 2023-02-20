//
//  Persistence.swift
//  WalletPace
//
//  Created by Pedro Silva on 11/02/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    private static var container: NSPersistentContainer = {
             let container = NSPersistentContainer(name: "WalletPace")
             container.loadPersistentStores { description, error in
                 if let error = error {
                      fatalError("Unable to load persistent stores: \(error)")
                 }
             }
             return container
         }()
     
     var context: NSManagedObjectContext {
         return Self.container.viewContext
     }
}
