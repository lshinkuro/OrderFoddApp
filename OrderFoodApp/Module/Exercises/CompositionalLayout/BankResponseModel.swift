//
//  BankResponseModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/11/24.
//

import Foundation

// MARK: - Models.swift
struct BankingData: Codable {
    let user: UserDataModel
    let balance: BalanceModel
    let expenses: ExpensesModel
    let pendingTransactions: [TransactionModel]
    let recentTransactions: [TransactionModel]
    
    
    enum CodingKeys: String, CodingKey {
        case user, balance, expenses
        case pendingTransactions = "pending_transactions"
        case recentTransactions = "recent_transactions"
    }
}

struct UserDataModel: Codable {
    let name: String
    let profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImage = "profile_image"
    }
}

struct BalanceModel: Codable {
    let amount: Double
    let cardNumber: String
    let cardHolder: String
    let expiryDate: String
    
    enum CodingKeys: String, CodingKey {
        case amount
        case cardNumber = "card_number"
        case cardHolder = "card_holder"
        case expiryDate = "expiry_date"
    }
}

struct ExpensesModel: Codable {
    let expense: Double
    let income: Double
}

struct TransactionModel: Codable {
    let id: String
    let name: String
    let amount: Double
    let type: TransactionType
    let icon: String
    let status: TransactionStatus?
    
    enum TransactionType: String, Codable {
        case credit
        case debit
    }
    
    enum TransactionStatus: String, Codable {
        case pending
        case completed
    }
}
