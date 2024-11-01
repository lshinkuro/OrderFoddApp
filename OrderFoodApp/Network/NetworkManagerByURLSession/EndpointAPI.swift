//
//  EndpointAPI.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/10/24.
//

import Foundation

enum ParameterEncodingU {
    case json
    case query
}


enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
}

enum EndpointAPI {
    case login(param: LoginParam)
    case getAllMenu
    case posts
    case getByCategory(type: String)
    case sendDataMedis(param: MedicalProfile)

    func path() -> String {
        switch self {
        case .login:
            return "/user/login"
        case .getAllMenu:
            return "/getAllMenu"
        case .posts:
            return "/posts"
        case .getByCategory:
            return "/getbycategory"
        case .sendDataMedis:
            return "/senddatamedic"
        }
    }

    func method() -> HTTPMethods {
        switch self {
        case .getAllMenu, .posts, .getByCategory :
            return .get
        case .login, .sendDataMedis:
            return .post
        }
    }

    // Untuk settinggan paramaeter body di setiap API
    var parameters: [String: Any]? {
        switch self {
        case .getAllMenu, .posts, .getByCategory:
            return nil
        case .login (let param):
            let params = [
                "username": param.username,
                "password": param.password
            ]
            return params
        case .sendDataMedis(let param):
            let encryptionManager = EncryptionManager()
            var ciphertext = Data()
            var nonce  = Data()
            do {
                let (x, y) = try encryptionManager.encryptMedicalProfile(profile: param)
                ciphertext = x
                nonce = y
            } catch {
                print("error")
            }
                  
            let params = [
                "ciphertext": ciphertext,
                "nonce": nonce
            ]
            return params
        }
    }

    // Untuk settinggan header di setiap API
    var headers: [String: String] {
        switch self {
        case .login:
            return [
                "Content-Type": "application/json",
            ]
        case .getAllMenu, .posts, .getByCategory, .sendDataMedis:
            return [
                "Content-Type": "application/json",
//                "Authorization" : "Bearer \(String(describing: readToken()))"
            ]
        }
    }
    
    // untuk setingan api yang menggunakan query params
    var queryParams: [String: Any]? {
        switch self {
        case .getAllMenu, .posts, .login, .sendDataMedis:
            return nil
        case .getByCategory(let param):
            let params = [
                "category": param,
            ]
            return params
        }
    }
    
    // Define encoding type based on the endpoint
     var encoding: ParameterEncodingU {
         switch self {
         case .getByCategory:
             return .query
         default:
             return .json
         }
     }
    
    // variabel  getter untuk menghasilkan full url dari api
    var urlString: String {
        switch self {
        case .login, .getAllMenu, .getByCategory, .sendDataMedis:
            return  BaseConstants.baseURL + self.path()
        case .posts:
            return  BaseConstants.baseURLPokemon + self.path()
        }
    }
    
    func readToken() -> String?{
        guard let tokenData = KeychainHelper.shared.read(forKey: KeychainHelperKey.firebaseAuthToken) else { return "" }
        let token = String(data: tokenData, encoding: .utf8)
        return token
    }
    
}

struct BaseConstants {
    static let baseURL = "http://localhost:3001/api/v1"
    static let baseURLPokemon = "https://jsonplaceholder.typicode.com"
    static let userDefaults = UserDefaults.standard
}



