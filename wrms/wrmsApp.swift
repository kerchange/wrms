//
//  wrmsApp.swift
//  wrms
//
//  Created by lws on 11/3/2025.
//

import SwiftUI
import CoreData
import UserNotifications

@main
struct WrmsApp: App {
    let persistenceController = PersistenceController.shared
    
    // For handling when app goes into background/foreground
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        // Setup notification permissions and scheduling
        NotificationManager.shared.requestPermissions { granted in
            if granted {
                NotificationManager.shared.scheduleExpiryCheckNotification()
                
                // Check for expiring items when app starts
                DispatchQueue.main.async {
                    NotificationManager.shared.checkExpiringItems(in: persistenceController.container.viewContext)
                }
            }
        }
        
        // Apply custom appearance settings
        setupAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                // App became active - reset badge count
                NotificationManager.shared.resetBadgeCount()
                
            case .background:
                // App went to background - save any pending changes
                saveContext()
                
                // Check for expiring items
                NotificationManager.shared.checkExpiringItems(in: persistenceController.container.viewContext)
                
            default:
                break
            }
        }
    }
    
    private func setupAppearance() {
        // Customize navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Customize tab bar appearance
        UITabBar.appearance().backgroundColor = UIColor.systemBackground
    }
    
    private func saveContext() {
        let context = persistenceController.container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView: View {
    @State private var selection = 0
    @State private var searchText = ""
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)
            
            NavigationView {
                SearchView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(1)
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(2)
        }
    }
}

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("expiryWarningDays") private var expiryWarningDays = 7
    
    var body: some View {
        Form {
            Section(header: Text("Notifications")) {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    .onChange(of: notificationsEnabled) { newValue in
                        if newValue {
                            NotificationManager.shared.requestPermissions { _ in }
                        }
                    }
                
                Stepper("Expiry Warning: \(expiryWarningDays) days", value: $expiryWarningDays, in: 1...30)
            }
            
            Section(header: Text("About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .foregroundColor(.secondary)
                }
                
                Button("Reset All Data") {
                    // Show confirmation dialog
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Settings")
    }
}
