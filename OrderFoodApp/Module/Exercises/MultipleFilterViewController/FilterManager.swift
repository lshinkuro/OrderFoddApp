//
//  FilterManager.swift
//  OrderFoodApp
//
//  Created by Phincon on 17/11/24.
//

import Foundation

// MARK: - FilterModel.swift
struct FilterModel {
    let title: String
    var isSelected: Bool
    let type: FilterType
}

enum FilterType {
    case brand
    case features
    case connectivity
}

// MARK: - FilterSingleton.swift
final class FilterManager {
    static let shared = FilterManager()
    
    private init() {}
    
    var selectedBrands: Set<String> = []
    var selectedFeatures: Set<String> = []
    var selectedConnectivity: Set<String> = []
    var priceRange: (min: Double, max: Double) = (1299, 3999)
    var discount: Double = 58
    
    func reset() {
        selectedBrands.removeAll()
        selectedFeatures.removeAll()
        selectedConnectivity.removeAll()
        priceRange = (1299, 3999)
        discount = 58
    }
}
