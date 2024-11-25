//
//  FilterManagerModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 17/11/24.
//

import Foundation


// MARK: - Dummy Data
let brandDataFilters: [FilterModel] = [
    FilterModel(title: "Philips", isSelected: false, type: .brand),
    FilterModel(title: "Sony", isSelected: false, type: .brand),
    FilterModel(title: "JBL", isSelected: false, type: .brand),
    FilterModel(title: "Headphones", isSelected: false, type: .brand),
    FilterModel(title: "Sennheiser", isSelected: false, type: .brand),
    FilterModel(title: "Motorola", isSelected: false, type: .brand),
    FilterModel(title: "Zebronics", isSelected: false, type: .brand),
    FilterModel(title: "iBall", isSelected: false, type: .brand),
    FilterModel(title: "Signature", isSelected: false, type: .brand),
    FilterModel(title: "Generic", isSelected: false, type: .brand)
]

let featuresDataFilters: [FilterModel] = [
    FilterModel(title: "Wireless", isSelected: false, type: .features),
    FilterModel(title: "Sports", isSelected: false, type: .features),
    FilterModel(title: "Noise Cancelling", isSelected: false, type: .features),
    FilterModel(title: "With Microphone", isSelected: false, type: .features),
    FilterModel(title: "Tangle Free Cord", isSelected: false, type: .features)
]

let connectivityDataFilters: [FilterModel] = [
    FilterModel(title: "Wired-3.5 MM Single Pin", isSelected: false, type: .connectivity),
    FilterModel(title: "Bluetooth Wireless", isSelected: false, type: .connectivity),
    FilterModel(title: "Wired USB", isSelected: false, type: .connectivity)
]
