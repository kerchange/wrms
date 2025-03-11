//
//  StoragePoint.swift
//  wrms
//
//  Created by lws on 12/3/2025.
//

import CoreData

class StoragePoint: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var xPosition: Double
    @NSManaged var yPosition: Double
    @NSManaged var storageArea: StorageArea
    @NSManaged var items: Set<Item>
}
