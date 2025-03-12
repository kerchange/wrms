//
//  SearchView.swift
//  wrms
//
//  Created by KENNY on 12/3/2025.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    @State private var searchResults: [Item] = []
    
    var body: some View {
        List {
            ForEach(searchResults, id: \.id) { item in
                NavigationLink(destination: ItemDetailView(item: item, isEditing: true)) {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        
                        Text("Location: \(item.storagePoint.storageArea.name) > \(item.storagePoint.name)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Search Results")
        .searchable(text: $searchText, prompt: "Search items")
        .onChange(of: searchText) { _ in
            performSearch()
        }
    }
    
    private func performSearch() {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }
        
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR itemDescription CONTAINS[cd] %@", searchText, searchText)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.name, ascending: true)]
        
        do {
            searchResults = try viewContext.fetch(request)
        } catch {
            print("Error performing search: \(error)")
            searchResults = []
        }
    }
}
