//
//  persistentContainer.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/18/24.
//

import Foundation
import CoreData

var persistentContainer: NSPersistentContainer = {
     let container = NSPersistentContainer(name: "CustomWorkoutEntity")
     container.loadPersistentStores(
         completionHandler: { (storeDescription, error) in
             if let error = error as NSError? {
                 fatalError("Unresolved error \(error), \(error.userInfo)")
             }
         })
     return container
 }()

 func saveContext () {
     let context = persistentContainer.viewContext
     if context.hasChanges {
         do {
             try context.save()
         } catch {
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
         }
     }
 }
