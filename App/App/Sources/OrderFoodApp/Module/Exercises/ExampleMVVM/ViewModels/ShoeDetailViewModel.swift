//
//  ShoeDetailViewModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 21/01/25.
//

import Foundation

class ShoeDetailViewModel {
    var shoeItem: ShoeItem

    init(shoeItem: ShoeItem) {
        self.shoeItem = shoeItem
    }

    func toggleFavorite() {
        shoeItem.isFavorite.toggle()
    }
}

