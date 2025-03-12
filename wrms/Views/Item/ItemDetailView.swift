//
//  ItemDetailView.swift
//  wrms
//
//  Created by KENNY on 12/3/2025.
//

import SwiftUI

struct ItemDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    // For creating a new item
    var storagePoint: StoragePoint?
    
    // For editing an existing item
    var item: Item?
    var isEditing: Bool
    
    @State private var name = ""
    @State private var itemDescription = ""
    @State private var expiryDate: Date = Date().addingTimeInterval(60*60*24*30) // Default to 30 days
    @State private var hasExpiryDate = false
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        Form {
            Section(header: Text("Item Details")) {
                TextField("Name", text: $name)
                
                TextField("Description (optional)", text: $itemDescription)
                    .frame(height: 100, alignment: .top)
                    .multilineTextAlignment(.leading)
            }
            
            Section(header: Text("Expiry Date")) {
                Toggle("Has Expiry Date", isOn: $hasExpiryDate)
                
                if hasExpiryDate {
                    DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                }
            }
            
            Section(header: Text("Photo")) {
                HStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    } else if let existingItem = item, let existingImage = existingItem.image {
                        Image(uiImage: existingImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    } else {
                        Text("No image selected")
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
                
                HStack {
                    Button("Take Photo") {
                        sourceType = .camera
                        isShowingImagePicker = true
                    }
                    
                    Spacer()
                    
                    Button("Choose from Library") {
                        sourceType = .photoLibrary
                        isShowingImagePicker = true
                    }
                }
            }
        }
        .navigationTitle(isEditing ? "Edit Item" : "Add Item")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Save" : "Add") {
                    if isEditing {
                        updateItem()
                    } else {
                        addItem()
                    }
                }
                .disabled(name.isEmpty)
            }
            
            if isEditing {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let existingItem = item {
                name = existingItem.name
                itemDescription = existingItem.itemDescription ?? ""
                if let date = existingItem.expiryDate {
                    expiryDate = date
                    hasExpiryDate = true
                }
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.id = UUID()
            newItem.name = name
            newItem.itemDescription = itemDescription.isEmpty ? nil : itemDescription
            newItem.expiryDate = hasExpiryDate ? expiryDate : nil
            
            if let image = selectedImage {
                newItem.imageData = image.jpegData(compressionQuality: 0.8)
            }
            
            newItem.storagePoint = storagePoint!
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                // Handle the error
                print("Error saving item: \(error)")
            }
        }
    }
    
    private func updateItem() {
        guard let existingItem = item else { return }
        
        withAnimation {
            existingItem.name = name
            existingItem.itemDescription = itemDescription.isEmpty ? nil : itemDescription
            existingItem.expiryDate = hasExpiryDate ? expiryDate : nil
            
            if let image = selectedImage {
                existingItem.imageData = image.jpegData(compressionQuality: 0.8)
            }
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                // Handle the error
                print("Error updating item: \(error)")
            }
        }
    }
}
