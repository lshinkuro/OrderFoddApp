//
//  ListView.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/10/24.
//

import Foundation
import SwiftUI

// FoodItem.swift
struct ListItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let description: String
}

// FoodListView.swift
struct ListView: View {
    let foods: [ListItem]
    let onItemSelected: ((ListItem) -> Void)?
    
    var body: some View {
        List(foods) { food in
            Button(action: {
                onItemSelected?(food)
            }) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(food.name)
                        .font(.headline)
                    Text("Rp \(food.price, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(food.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
        }
    }
}

// 6. Perbaiki preview dengan memberikan closure dummy
#Preview {
    ListView(foods: [ListItem(name: "Nasi Goreng", price: 25000, description: "Nasi goreng spesial dengan telur dan ayam")]) { food in
        print("Selected food: \(food.name)")
    }
}

