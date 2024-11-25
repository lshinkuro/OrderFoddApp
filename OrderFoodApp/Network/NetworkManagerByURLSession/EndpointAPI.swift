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
    case register(param: RegisterParam)
    case getAllMenu
    case posts
    case getByCategory(type: String)
    case sendDataMedis(param: MedicalProfile)
    case createOrder(param: CreateOrderParam)
    case getDataBank

    func path() -> String {
        switch self {
        case .login:
            return "/phincon/auth/login"
        case .register:
            return "/auth/cofa/register"
        case .getAllMenu:
            return "/getAllMenu"
        case .posts:
            return "/posts"
        case .getByCategory:
            return "/getbycategory"
        case .sendDataMedis:
            return "/senddatamedic"
        case .createOrder:
            return "/phincon/api/cofa/order/snap"
        case .getDataBank:
            return "/banking-data"
        }
    }

    func method() -> HTTPMethods {
        switch self {
        case .getAllMenu, .posts, .getByCategory, .getDataBank:
            return .get
        case .login, .sendDataMedis, .register, .createOrder:
            return .post
        }
    }

    // Untuk settinggan paramaeter body di setiap API
    var parameters: [String: Any]? {
        switch self {
        case .getAllMenu, .posts, .getByCategory, .getDataBank:
            return nil
        case .login (let param):
            let params = [
                "username": param.username,
                "password": param.password
            ]
            return params
        case .register (let param):
            let params = [
                "username": param.username,
                "password": param.password,
                "email": param.email,
                "phoneNumber": param.phoneNumber,
                "fullname": param.fullname
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
        
        case .createOrder(let param):
            let itemDetails: [[String: Any]] = param.items.map { item in
                 return [
                    "id": item.id,
                     "name": item.name,
                     "price": item.price,
                     "quantity": item.quantity
                 ]
             }
             
             let params: [String: Any] = [
                "email": param.email,
                "items": itemDetails,
                "amount": param.amount,
                "callbacks": [
                     "finish": "https://facebook.com",
                     "error": "https://youtube.com"
                 ]
             ]
             return params
        }
    }

    // Untuk settinggan header di setiap API
    var headers: [String: String] {
        switch self {
        case .login, .register, .getDataBank:
            return [
                "Content-Type": "application/json",
            ]
        case .getAllMenu, .posts, .getByCategory, .sendDataMedis, .createOrder:
            return [
                "Content-Type": "application/json",
//                "Authorization" : "Bearer \(String(describing: readToken()))",
                "x-user-id" : "3",
                "x-secret-app": "]k!aMHCRG=2]N6WGeYNw@3#$[:V4Wr"
            ]
        }
    }
    
    // untuk setingan api yang menggunakan query params
    var queryParams: [String: Any]? {
        switch self {
        case .getAllMenu, .posts, .login, .sendDataMedis, .register, .createOrder, .getDataBank:
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
        case .getAllMenu, .getDataBank:
            return  BaseConstants.baseURL + self.path()
        default:
            return  Constants.baseURL + self.path()
        }
    }
    
    func readToken() -> String {
        guard let tokenData = KeychainHelper.shared.read(forKey: KeychainHelperKey.firebaseAuthToken) else { return "" }
        let token = String(data: tokenData, encoding: .utf8) ?? ""
        return token
    }
    
}

struct BaseConstants {
    static let baseURL = "http://localhost:3001/api/v1"
    static let baseURLPokemon = "https://jsonplaceholder.typicode.com"
    static let userDefaults = UserDefaults.standard
}



