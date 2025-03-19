//
//  Item.swift
//  wrms
//
//  Created by lws on 19/3/2025.
//

import CoreData
import UIKit

@objc(Item)
public class Item: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var itemDescription: String?
    @NSManaged public var expiryDate: Date?
    @NSManaged public var imageData: Data?
    @NSManaged public var storagePoint: StoragePoint?
    
    // Add convenience computed properties for non-optional access
    var nonOptionalName: String {
        return name ?? ""
    }
}
