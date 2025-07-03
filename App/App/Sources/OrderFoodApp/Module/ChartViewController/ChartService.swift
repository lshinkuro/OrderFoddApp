//
//  ChartModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 01/10/24.
//

import Foundation

typealias CartTupleModel = (food: FoodItem, quantity: Int)


class CartService {
    
    static let shared = CartService()
    private init() {}

    private var cartItems: [FoodItem: Int] = [:]

    func addToCart(food: FoodItem) {
        cartItems[food, default: 0] += 1
    }

    func removeFromCart(food: FoodItem) {
        guard let count = cartItems[food], count > 0 else { return }
        if count == 1 {
            cartItems.removeValue(forKey: food)
        } else {
            cartItems[food] = count - 1
        }
    }

    
    func getCartItems() -> [(food: FoodItem, quantity: Int)] {
        return cartItems.map { ($0.key, $0.value) }
    }

    func clearCart() {
        cartItems.removeAll()
    }

    func getTotalQuantity() -> Int {
        return cartItems.values.reduce(0, +)
    }
}



