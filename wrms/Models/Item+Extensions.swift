//
//  Item+Extensions.swift
//  wrms
//
//  Created by lws on 19/3/2025.
//

import Foundation
import UIKit
import CoreData

extension Item {
    // MARK: - Computed Properties
    
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
    
    var isExpired: Bool {
        guard let expiryDate = expiryDate else { return false }
        return expiryDate < Date()
    }
    
    // Helper property for UI
    var displayName: String {
        return name ?? "Unnamed Item"
    }
    
    // MARK: - Static Methods
    
    static func create(in context: NSManagedObjectContext,
                       name: String,
                       description: String?,
                       expiryDate: Date?,
                       image: UIImage?,
                       storagePoint: StoragePoint) -> Item {
        let item = Item(context: context)
        item.id = UUID()
        item.name = name
        item.itemDescription = description
        item.expiryDate = expiryDate
        item.imageData = image?.jpegData(compressionQuality: 0.8)
        item.storagePoint = storagePoint
        return item
    }
    
    // Search for items by name or description
    static func search(with searchText: String, in context: NSManagedObjectContext) -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(
            format: "name CONTAINS[cd] %@ OR itemDescription CONTAINS[cd] %@",
            searchText, searchText
        )
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.name, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error searching for items: \(error)")
            return []
        }
    }
    
    // Fetch expiring items within days
    static func fetchExpiring(within days: Int, in context: NSManagedObjectContext) -> [Item] {
        let today = Date()
        let calendar = Calendar.current
        let futureDate = calendar.date(byAdding: .day, value: days, to: today)!
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(
            format: "expiryDate != nil AND expiryDate >= %@ AND expiryDate <= %@",
            today as NSDate,
            futureDate as NSDate
        )
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.expiryDate, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching expiring items: \(error)")
            return []
        }
    }
}
