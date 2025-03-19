//
//  StorageArea+Extensions.swift
//  wrms
//
//  Created by lws on 19/3/2025.
//

import Foundation
import UIKit
import CoreData

extension StorageArea {
    // Convenience property to get the UIImage from imageData
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    // Computed property to get the count of storage points
    var storagePointsCount: Int {
        return storagePoints?.count ?? 0
    }
    
    // Convenience method to create a new StorageArea
    static func create(in context: NSManagedObjectContext, name: String, image: UIImage?) -> StorageArea {
        let storageArea = StorageArea(context: context)
        storageArea.id = UUID()
        storageArea.name = name
        storageArea.imageData = image?.jpegData(compressionQuality: 0.8)
        return storageArea
    }
    
    // Get all storage areas sorted by name
    static func fetchAllSorted(in context: NSManagedObjectContext) -> [StorageArea] {
        let request: NSFetchRequest<StorageArea> = StorageArea.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \StorageArea.name, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching storage areas: \(error)")
            return []
        }
    }
}
