//
//  HomeView.swift
//  wrms
//
//  Created by KENNY on 12/3/2025.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \StorageArea.name, ascending: true)],
        animation: .default)
    private var storageAreas: FetchedResults<StorageArea>
    
    @State private var isShowingImagePicker = false
    @State private var isShowingCamera = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isShowingNamePrompt = false
    @State private var newStorageName = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(storageAreas, id: \.id) { storageArea in
                    NavigationLink(destination: StorageAreaDetailView(storageArea: storageArea)) {
                        HStack {
                            if let image = storageArea.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 60, height: 60)
                            }
                            
                            Text(storageArea.name)
                                .font(.headline)
                        }
                    }
                }
                .onDelete(perform: deleteStorageAreas)
            }
            .navigationTitle("My Storage")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Take Photo") {
                            sourceType = .camera
                            isShowingCamera = true
                        }
                        Button("Choose from Library") {
                            sourceType = .photoLibrary
                            isShowingImagePicker = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
                    .onDisappear {
                        if selectedImage != nil {
                            isShowingNamePrompt = true
                        }
                    }
            }
            .sheet(isPresented: $isShowingCamera) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                    .onDisappear {
                        if selectedImage != nil {
                            isShowingNamePrompt = true
                        }
                    }
            }
            .alert("Name your storage", isPresented: $isShowingNamePrompt) {
                TextField("Storage name", text: $newStorageName)
                
                Button("Cancel", role: .cancel) {
                    selectedImage = nil
                    newStorageName = ""
                }
                
                Button("Save") {
                    addStorageArea()
                }
            }
        }
        .searchable(text: $searchText)
    }
    
    @State private var searchText = ""
    
    var searchResults: [Item] {
        // This would be implemented to search across all items
        // We'll add this functionality later
        return []
    }
    
    private func addStorageArea() {
        guard let image = selectedImage, !newStorageName.isEmpty else {
            return
        }
        
        withAnimation {
            let newStorageArea = StorageArea(context: viewContext)
            newStorageArea.id = UUID()
            newStorageArea.name = newStorageName
            newStorageArea.imageData = image.jpegData(compressionQuality: 0.8)
            
            do {
                try viewContext.save()
                selectedImage = nil
                newStorageName = ""
            } catch {
                // Handle the error
                print("Error saving storage area: \(error)")
            }
        }
    }
    
    private func deleteStorageAreas(offsets: IndexSet) {
        withAnimation {
            offsets.map { storageAreas[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Handle the error
                print("Error deleting storage areas: \(error)")
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            picker.dismiss(animated: true)
        }
    }
}
