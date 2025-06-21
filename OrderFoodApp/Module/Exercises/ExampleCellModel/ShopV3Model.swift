//
//  ShopV3Model.swift
//  OrderFoodApp
//
//  Created by Phincon on 27/03/25.
//


struct OfferModel {
    let title: String
    let discount: String
}

struct ProductModel {
    let name: String
    let price: String
}

struct PromotionModel {
    let bannerImage: String
}

/// Enum untuk handle berbagai jenis data yang bisa ada dalam cell
enum ShopV3CellType {
    case offer(OfferModel)
    case product(ProductModel)
    case promotion(PromotionModel)
    case skeleton
    case error
}


