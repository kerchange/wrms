//
//  StorageArea.swift
//  wrms
//
//  Created by lws on 12/3/2025.
//

import CoreData
import UIKit

class StorageArea: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var imageData: Data?
    @NSManaged var storagePoints: Set<StoragePoint>
    
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
}
