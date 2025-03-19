//
//  SettingsView.swift
//  wrms
//
//  Created by lws on 19/3/2025.
//

import SwiftUI

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
