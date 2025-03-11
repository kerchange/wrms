//
//  wrmsApp.swift
//  wrms
//
//  Created by lws on 11/3/2025.
//

import SwiftUI

@main
struct wrmsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
