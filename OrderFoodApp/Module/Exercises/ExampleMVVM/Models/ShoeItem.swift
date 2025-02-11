//
//  ShoeItem.swift
//  OrderFoodApp
//
//  Created by Phincon on 21/01/25.
//

import Foundation

struct ShoeItem {
    let id: Int
    let name: String
    let description: String
    var isFavorite: Bool
}

enum DataState {
    case loading
    case success
    case empty
    case error(String) // Error message
}

