//
//  DashboardModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 01/10/24.
//

import Foundation


// Enum for category types
enum FoodCategory: String, CaseIterable, Codable {
    case pizza
    case burger
    case sausage
    case sandwich
    
    func setImage() -> String {
        switch self {
        case .pizza:
            return "delicious-italian-food"
        case .burger:
            return "burger"
        case .sausage:
            return "sausage"
        case .sandwich:
            return "sandwich"
        }
    }
}


// MARK: - Welcome
struct FoodModel: Codable {
    let foodData: [FoodCategoryData]
    let promoData: [PromoFoodData]
    let adsData: [AdsFoodData]
    let special: [FoodItem]
}

// Struct to map food items to categories
struct FoodCategoryData: Codable {
    let category: FoodCategory
    let items: [FoodItem]
}

// Struct to represent each food item
struct FoodItem: Hashable, Codable {
    let name: String
    let description: String
    let image: String
    let rating: Double
    let isFavorite: Bool
    let price: Double
    var discount: Double? = nil
}

struct PromoFoodData: Codable {
    let name: String
    let image: String
    let diskonCharge: Double
}

struct AdsFoodData: Codable {
    let name: String
    let image: String
    let urlString: String
}


// Sample data for each category
let foodData: [FoodCategoryData] = [
    FoodCategoryData(category: .pizza,
                     items: [
                        FoodItem(name: "Pepperoni Pizza",
                                 description: "Classic pepperoni pizza",
                                 image: "delicious-italian-food",
                                 rating: 4.5,
                                 isFavorite: true,
                                 price: 11500),
                        FoodItem(name: "Cheese Pizza",
                                 description: "Extra cheese",
                                 image: "delicious-italian-food",
                                 rating: 4.0,
                                 isFavorite: false,
                                 price: 12500)
                     ]),
    FoodCategoryData(category: .burger,
                     items: [
                        FoodItem(name: "Big cheese burger",
                                 description: "No 10 opp lekki phase 1",
                                 image: "burger-items",
                                 rating: 4.0,
                                 isFavorite: true,
                                 price: 13400),
                        FoodItem(name: "Medium cheese burger",
                                 description: "No 10 opp lekki phase 1",
                                 image: "burger-items",
                                 rating: 4.0,
                                 isFavorite: false,
                                 price: 19000),
                        FoodItem(name: "Large cheese burger",
                                 description: "No 11 opp lekki phase 2",
                                 image: "burger-items",
                                 rating: 4.8, isFavorite: true,
                                 price: 23000),
                        FoodItem(name: "Pancake cheese burger",
                                 description: "No 1 best pancake burger",
                                 image: "burger-items",
                                 rating: 4.6,
                                 isFavorite: true,
                                 price: 16500),
                     ])
    // Add data for sausage and sandwich categories similarly...
]


let dataPromo: [PromoFoodData] = [
    PromoFoodData(name: "Pizza Marzano", image: "promo1", diskonCharge: 0.5),
    PromoFoodData(name: "Burger King", image: "promo2", diskonCharge: 0.1),
    PromoFoodData(name: "Sausage King", image: "promo3", diskonCharge: 0.2),
    PromoFoodData(name: "Coffee", image: "promo3", diskonCharge: 0.3),
]



let adsData: [AdsFoodData] = [
    AdsFoodData(name: "burger kill", image: "ads1", urlString: "https://www.foodandwine.com/recipes/tocino-burgers"),
    AdsFoodData(name: "pizza kill", image: "ads2", urlString: "https://www.foodandwine.com/cooking-techniques/the-story-of-thai-curry-according-to-a-chef-and-a-lifelong-fan"),
    AdsFoodData(name: "sausage kill", image: "ads1", urlString: "https://www.foodandwine.com/inasal-filipino-grilled-chicken-8635082"),
    AdsFoodData(name: "paparoni kill", image: "ads2", urlString: "https://www.foodandwine.com/shiitake-mushroom-soupy-rice-recipe-8422275"),
    AdsFoodData(name: "pizza kill", image: "ads1", urlString: "https://www.foodandwine.com/perkedel-kentang-indonesian-potato-fritters-7253406"),
]

