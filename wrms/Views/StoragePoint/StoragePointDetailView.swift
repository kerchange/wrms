//
//  StoragePointDetailView.swift
//  wrms
//
//  Created by KENNY on 12/3/2025.
//

import SwiftUI

struct StoragePointDetailView: View {
    @ObservedObject var storagePoint: StoragePoint
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isShowingAddItemView = false
    
    var body: some View {
        List {
            ForEach(Array(storagePoint.items), id: \.id) { item in
                NavigationLink(destination: ItemDetailView(item: item, isEditing: true)) {
                    HStack {
                        if let image = item.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 50, height: 50)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            
                            if let description = item.itemDescription, !description.isEmpty {
                                Text(description)
                                    .font(.subheadline)
                                    .lineLimit(1)
                            }
                            
                            if let expiryDate = item.expiryDate {
                                HStack {
                                    Text("Expires: \(expiryDate, formatter: dateFormatter)")
                                        .font(.caption)
                                    
                                    if item.isExpiringSoon {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.orange)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle(storagePoint.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add Item") {
                    isShowingAddItemView = true
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
        }
        .sheet(isPresented: $isShowingAddItemView) {
            NavigationView {
                ItemDetailView(storagePoint: storagePoint, isEditing: false)
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            let itemsArray = Array(storagePoint.items)
            offsets.map { itemsArray[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Handle the error
                print("Error deleting items: \(error)")
            }
        }
    }
}
