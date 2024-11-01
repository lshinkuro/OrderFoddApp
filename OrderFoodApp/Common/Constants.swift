//
//  Constants.swift
//  OrderFoodApp
//
//  Created by Phincon on 28/10/24.
//

import Foundation


struct Constants {
    
    public static var baseURL: String {
        return Bundle.main.infoDictionary?["BASE_URL"] as? String ?? ""
    }
    
}
