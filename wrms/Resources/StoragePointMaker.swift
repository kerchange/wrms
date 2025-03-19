//
//  StoragePointMaker.swift
//  wrms
//
//  Created by lws on 19/3/2025.
//

import SwiftUI

struct StoragePointMarker: View {
    let name: String
    let isSelected: Bool
    
    var body: some View {
        Text(name)
            .font(.system(size: 24))
            .padding(isSelected ? 12 : 8)
            .background(
                Circle()
                    .fill(isSelected ? Color.blue.opacity(0.8) : Color.white.opacity(0.8))
            )
            .overlay(
                Circle()
                    .stroke(Color.blue, lineWidth: 2)
                    .opacity(isSelected ? 1 : 0.7)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}
