//
//  StorageArea.swift
//  wrms
//
//  Created by lws on 19/3/2025.
//

import Foundation
import CoreData
import UIKit

@objc(StorageArea)
public class StorageArea: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var storagePoints: NSSet?
    
    // Add convenience computed properties
    var nonOptionalName: String {
        return name ?? ""
    }
    
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    // Type-safe accessors for relationships
    var storagePointsArray: [StoragePoint] {
        let set = storagePoints as? Set<StoragePoint> ?? []
        return Array(set)
    }
}
