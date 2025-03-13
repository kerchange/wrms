//
//  NotificationManager.swift
//  wrms
//
//  Created by lws on 13/3/2025.
//

import Foundation
import UserNotifications
import CoreData

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermissions(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
            completion(granted)
        }
    }
    
    func scheduleExpiryCheckNotification() {
        let center = UNUserNotificationCenter.current()
        
        // Create a daily trigger at 9:00 AM
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create the request
        let content = UNMutableNotificationContent()
        content.title = "Check Expiring Items"
        content.body = "Some items may be expiring soon. Open the app to check."
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "com.wrms.dailyExpiryCheck",
            content: content,
            trigger: trigger
        )
        
        // Add the request
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func checkExpiringItems(in context: NSManagedObjectContext) {
        // Get today and +7 days for the check
        let today = Date()
        let calendar = Calendar.current
        let sevenDaysLater = calendar.date(byAdding: .day, value: 7, to: today)!
        
        // Create fetch request for items that expire within the next 7 days
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.predicate = NSPredicate(
            format: "expiryDate != nil AND expiryDate >= %@ AND expiryDate <= %@",
            today as NSDate,
            sevenDaysLater as NSDate
        )
        
        do {
            let expiringItems = try context.fetch(request)
            scheduleExpiryNotifications(for: expiringItems)
        } catch {
            print("Error fetching expiring items: \(error)")
        }
    }
    
    private func scheduleExpiryNotifications(for items: [Item]) {
        let center = UNUserNotificationCenter.current()
        
        // Remove existing expiry notifications
        center.removePendingNotificationRequests(withIdentifiers: items.map { "expiry-\($0.id.uuidString)" })
        
        for item in items {
            guard let expiryDate = item.expiryDate else { continue }
            
            // Calculate days until expiry
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: Date(), to: expiryDate)
            guard let daysUntilExpiry = components.day, daysUntilExpiry >= 0 else { continue }
            
            // Create notification content
            let content = UNMutableNotificationContent()
            
            if daysUntilExpiry == 0 {
                content.title = "\(item.name) expires today!"
            } else if daysUntilExpiry == 1 {
                content.title = "\(item.name) expires tomorrow!"
            } else {
                content.title = "\(item.name) expires in \(daysUntilExpiry) days"
            }
            
            content.body = "Stored in: \(item.storagePoint.storageArea.name) > \(item.storagePoint.name)"
            content.sound = .default
            content.badge = 1
            
            // Create trigger based on expiry date
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: expiryDate)
            dateComponents.hour = 8 // Notify at 8:00 AM
            dateComponents.minute = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            // Create request
            let request = UNNotificationRequest(
                identifier: "expiry-\(item.id.uuidString)",
                content: content,
                trigger: trigger
            )
            
            // Add request
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling expiry notification: \(error)")
                }
            }
        }
    }
    
    func resetBadgeCount() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
}
