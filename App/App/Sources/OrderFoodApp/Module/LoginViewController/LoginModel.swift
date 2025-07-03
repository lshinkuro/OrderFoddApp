//
//  LoginModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 16/10/24.
//

import Foundation



// MARK: - Welcome
struct LoginResponseModel: Codable {
    let code: Int
    let message: String
    let data: LoginResponseData
}

// MARK: - DataClass
struct LoginResponseData: Codable {
    let usUsername: String
    let usID: Int
    let usEmail, usFullname, usPhoneNumber: String
    let usActive: Bool
    let roles: [Role]
    let token: String?

    enum CodingKeys: String, CodingKey {
        case usUsername = "us_username"
        case usID = "us_id"
        case usEmail = "us_email"
        case usFullname = "us_fullname"
        case usPhoneNumber = "us_phone_number"
        case usActive = "us_active"
        case roles, token
    }
}

// MARK: - Role
struct Role: Codable {
    let rlCode: String

    enum CodingKeys: String, CodingKey {
        case rlCode = "rl_code"
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
