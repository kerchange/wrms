//
//  Item.swift
//  wrms
//
//  Created by lws on 12/3/2025.
//

import Foundation
import CoreData
import UIKit

class Item: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var itemDescription: String?
    @NSManaged var expiryDate: Date?
    @NSManaged var imageData: Data?
    @NSManaged var storagePoint: StoragePoint
    
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    var isExpiringSoon: Bool {
        guard let expiryDate = expiryDate else { return false }
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.day], from: today, to: expiryDate)
        return components.day ?? 0 <= 7 && components.day ?? 0 >= 0
    }
}
