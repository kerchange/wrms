//
//  StorageAreaCard.swift
//  wrms
//
//  Created by lws on 19/3/2025.
//

import SwiftUI

struct StorageAreaCard: View {
    let storageArea: StorageArea
    
    var body: some View {
        VStack {
            if let image = storageArea.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(12, corners: [.topLeft, .topRight])
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 150)
                    .cornerRadius(12, corners: [.topLeft, .topRight])
            }
            
            HStack {
                Text(storageArea.name)
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                
                Spacer()
                
                Text("\(storageArea.storagePoints.count) points")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .background(Color(.systemBackground))
            .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
