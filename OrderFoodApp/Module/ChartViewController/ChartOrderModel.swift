//
//  ChartOrderModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 11/11/24.
//

import Foundation


// MARK: - Welcome
struct OrderModel: Codable {
    let status: String
    let code: Int
    let message: String
    let data: OrderDataModel
}

// MARK: - DataClass
struct OrderDataModel: Codable {
    let orUpdatedOn: String
    let orID, orUsID, orTotalPrice: Int
    let orStatus, orPaymentStatus, orPlatformID, orTokenID: String
    let orTag: String
    let orActive: Bool
    let orCreatedOn: String
    let orCreatedBy: Int
    let orUpdatedBy: String?
    let transaction: Transaction

    enum CodingKeys: String, CodingKey {
        case orUpdatedOn = "or_updated_on"
        case orID = "or_id"
        case orUsID = "or_us_id"
        case orTotalPrice = "or_total_price"
        case orStatus = "or_status"
        case orPaymentStatus = "or_payment_status"
        case orPlatformID = "or_platform_id"
        case orTokenID = "or_token_id"
        case orTag = "or_tag"
        case orActive = "or_active"
        case orCreatedOn = "or_created_on"
        case orCreatedBy = "or_created_by"
        case orUpdatedBy = "or_updated_by"
        case transaction
    }
}

// MARK: - Transaction
struct Transaction: Codable {
    let token: String
    let redirectURL: String

    enum CodingKeys: String, CodingKey {
        case token
        case redirectURL = "redirect_url"
    }
}
