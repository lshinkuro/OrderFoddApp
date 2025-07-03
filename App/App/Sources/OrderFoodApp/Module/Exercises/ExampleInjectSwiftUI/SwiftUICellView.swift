//
//  SwiftUICellView.swift
//  OrderFoodApp
//
//  Created by Phincon on 06/02/25.
//

import Foundation
import UIKit
import SwiftUI

struct SwiftUICellView: View {
    let title: String
    let subtitle: String
    let onButtonTap: () -> Void
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .padding(.vertical, 8)
                Text(subtitle)
                    .font(.caption)
                    .padding()
                Divider()
            }
            Spacer()
            Button(action: {
                onButtonTap()
            }) {
                Image(systemName: "info.circle")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .padding(.trailing, 16)
            
        }
        .padding(.horizontal)
        .background(Color.white)
    }
}


import SwiftUI

struct SwiftUICellViewV2: View {
    
    let title: String
    let subtitle: String
    let imageUrl: String
    let onButtonTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Gambar di kiri
            AsyncImage(url: URL(string: imageUrl)) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 4)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Tombol dengan animasi
            Button(action: {
                withAnimation {
                    onButtonTap()
                }
            }) {
                Image(systemName: "info.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding()
                    .background(Circle().fill(Color.white).shadow(radius: 2))
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
}

// Custom Button Style (Animasi Saat Ditekan)
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}
