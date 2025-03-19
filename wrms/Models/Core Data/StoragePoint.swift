//
//  StoragePoint.swift
//  wrms
//
//  Created by lws on 19/3/2025.
//

import Foundation
import CoreData

@objc(StoragePoint)
public class StoragePoint: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var xPosition: Double
    @NSManaged public var yPosition: Double
    @NSManaged public var storageArea: StorageArea?
    @NSManaged public var items: NSSet?
    
    // Add convenience computed properties
    var nonOptionalName: String {
        return name ?? ""
    }
    
    // Type-safe accessors for relationships
    var itemsArray: [Item] {
        let set = items as? Set<Item> ?? []
        return Array(set)
    }
}
