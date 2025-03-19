//
//  ItemRow.swift
//  wrms
//
//  Created by lws on 19/3/2025.
//

import SwiftUI

struct ItemRow: View {
    let item: Item
    let dateFormatter: DateFormatter
    
    init(item: Item) {
        self.item = item
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .none
    }
    
    var body: some View {
        HStack(spacing: 16) {
            if let image = item.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                
                if let description = item.itemDescription, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                if let expiryDate = item.expiryDate {
                    HStack {
                        Text("Expires: \(expiryDate, formatter: dateFormatter)")
                            .font(.caption)
                            .foregroundColor(item.isExpiringSoon ? .red : .secondary)
                        
                        if item.isExpiringSoon {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
