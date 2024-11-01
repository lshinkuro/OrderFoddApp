//
//  LoginModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 16/10/24.
//

import Foundation


struct LoginResponseModel: Codable {
    let status, message: String
    let data: LoginResponseData
}

// MARK: - DataClass
struct LoginResponseData: Codable {
    let user: UserData
    let token: TokenData
}

// MARK: - Token
struct TokenData: Codable {
    let accessToken, refreshToken: String?
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
}

// MARK: - User
struct UserData: Codable {
    let id: Int
    let name, email, phone: String
    let profilePictureURL: String
    let roles: [String]
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone
        case profilePictureURL = "profile_picture_url"
        case roles
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
