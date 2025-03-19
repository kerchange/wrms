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
    @objc(addStoragePointsObject:)
    @NSManaged public func addToStoragePoints(_ value: StoragePoint)
    
    @objc(removeStoragePointsObject:)
    @NSManaged public func removeFromStoragePoints(_ value: StoragePoint)
    
    @objc(addStoragePoints:)
    @NSManaged public func addToStoragePoints(_ values: NSSet)
    
    @objc(removeStoragePoints:)
    @NSManaged public func removeFromStoragePoints(_ values: NSSet)
}
