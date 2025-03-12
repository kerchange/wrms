//
//  StorageAreaDetailView.swift
//  wrms
//
//  Created by KENNY on 12/3/2025.
//

import SwiftUI

struct StorageAreaDetailView: View {
    @ObservedObject var storageArea: StorageArea
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isAddingStoragePoint = false
    @State private var tapPosition: CGPoint?
    @State private var newPointName = ""
    @State private var isShowingNamePrompt = false
    
    var body: some View {
        ZStack {
            if let image = storageArea.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture { location in
                        if isAddingStoragePoint {
                            tapPosition = location
                            isShowingNamePrompt = true
                        }
                    }
                
                // Overlay the storage points
                ForEach(Array(storageArea.storagePoints), id: \.id) { point in
                    NavigationLink(destination: StoragePointDetailView(storagePoint: point)) {
                        Text(point.name)
                            .font(.system(size: 24))
                            .padding(8)
                            .background(Circle().fill(Color.white.opacity(0.8)))
                    }
                    .position(x: CGFloat(point.xPosition), y: CGFloat(point.yPosition))
                }
            } else {
                Text("No image available")
                    .font(.headline)
            }
        }
        .navigationTitle(storageArea.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isAddingStoragePoint ? "Done" : "Add Point") {
                    isAddingStoragePoint.toggle()
                }
            }
        }
        .alert("Name your storage point", isPresented: $isShowingNamePrompt) {
            TextField("Name or emoji", text: $newPointName)
            
            Button("Cancel", role: .cancel) {
                tapPosition = nil
                newPointName = ""
            }
            
            Button("Save") {
                addStoragePoint()
            }
        }
    }
    
    private func addStoragePoint() {
        guard let position = tapPosition, !newPointName.isEmpty else {
            return
        }
        
        withAnimation {
            let newPoint = StoragePoint(context: viewContext)
            newPoint.id = UUID()
            newPoint.name = newPointName
            newPoint.xPosition = Double(position.x)
            newPoint.yPosition = Double(position.y)
            newPoint.storageArea = storageArea
            
            do {
                try viewContext.save()
                tapPosition = nil
                newPointName = ""
                isAddingStoragePoint = false
            } catch {
                // Handle the error
                print("Error saving storage point: \(error)")
            }
        }
    }
}
