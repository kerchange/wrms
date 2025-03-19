//
//  StoragePoint+Extensions.swift
//  wrms
//
//  Created by lws on 19/3/2025.
//

import Foundation
import CoreData

extension StoragePoint {
    // Convenience property to get items as an array
    var itemsArray: [Item] {
        return items?.allObjects as? [Item] ?? []
    }
    
    // Convenience method to create a new StoragePoint
    static func create(in context: NSManagedObjectContext,
                       name: String,
                       x: Double,
                       y: Double,
                       storageArea: StorageArea) -> StoragePoint {
        let point = StoragePoint(context: context)
        point.id = UUID()
        point.name = name
        point.xPosition = x
        point.yPosition = y
        point.storageArea = storageArea
        return point
    }
    
    // Get all storage points for a specific storage area
    static func fetch(for storageArea: StorageArea, in context: NSManagedObjectContext) -> [StoragePoint] {
        let request: NSFetchRequest<StoragePoint> = StoragePoint.fetchRequest()
        request.predicate = NSPredicate(format: "storageArea == %@", storageArea)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \StoragePoint.name, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching storage points: \(error)")
            return []
        }
    }
}
