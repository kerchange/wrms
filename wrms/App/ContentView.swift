//
//  ContentView.swift
//  wrms
//
//  Created by lws on 11/3/2025.
//

import SwiftUI
import CoreData

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
