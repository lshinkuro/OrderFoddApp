//
//  ShoeService.swift
//  OrderFoodApp
//
//  Created by Phincon on 21/01/25.
//

import Foundation


class ShoeService {
    func fetchShoeItems(completion: @escaping  (Result<[ShoeItem], Error>) -> Void) {
        // Simulasi API Call
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let items = [
                ShoeItem(id: 1, name: "Brodo", description: "Modern Shoe Trendy", isFavorite: false),
                ShoeItem(id: 2, name: "Canvas", description: "Luxury Design Sporty", isFavorite: true),
                ShoeItem(id: 3, name: "Adidas", description: "Modern Casual Vintage", isFavorite: false)
            ]
//            completion(.success(items))
            
            // Simulate empty state
//            completion(.success([]))
           
           // Simulate error
            completion(.failure(NSError(domain: "Network Error", code: -1, userInfo: nil)))
        }
    }
}


