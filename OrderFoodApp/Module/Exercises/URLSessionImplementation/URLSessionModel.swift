//
//  URLSessioModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/10/24.
//

import Foundation
import UIKit

typealias Datum = [PlaceholderItem]

// MARK: - Welcome
struct PlaceholderItem: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}


// MARK: - Welcome
struct FoodCategoryItem: Codable {
    let category: Category
    let items: [ItemCategory]
}

// MARK: - Category
struct Category: Codable {
    let name, description, image: String
}

// MARK: - Item
struct ItemCategory: Codable {
    let id: Int
    let name: String
    let price, rating: Double
    let reviews: Int
    let image: String
    let isFavorite: Bool
    let description: String
}





