//
//  Endpoint.swift
//  OrderFoodApp
//
//  Created by Phincon on 11/10/24.
//

import Foundation
import Alamofire

enum Endpoint {
    
    case getAllMenu
    case getByCategory(type: String)
    
    
    func path() -> String {
        switch self {
        case .getAllMenu:
            return "/getAllMenu"
        case .getByCategory:
            return "/getbycategory"
        }
    }

    func method() -> HTTPMethod {
        switch self {
        case .getAllMenu, .getByCategory:
          return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .getAllMenu, .getByCategory:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }

    var headers: HTTPHeaders {
        switch self {
        case .getAllMenu, .getByCategory:
            let params: HTTPHeaders  = [
                "Content-Type": "application/json",
            ]
            return params
        }
    }
    
    var queryParams: [String: Any]? {
        switch self {
        case .getAllMenu:
            return nil
        case .getByCategory(let item):
            let params  = [
                "category": item,
            ]
            return params
        }
    }
    
    var urlString: String {
        return Constants.baseURL + self.path()
    }
}

struct BaseConstant {
    static let baseURL = "http://localhost:3001/api/v1"
    static let userDefaults = UserDefaults.standard
}
