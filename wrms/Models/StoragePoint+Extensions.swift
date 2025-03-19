//
//  StoragePoint+Extensions.swift
//  wrms
//
//  Created by lws on 19/3/2025.
//

import Foundation
import CoreData

extension StoragePoint {
    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)
    
    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)
    
    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)
    
    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)
}
