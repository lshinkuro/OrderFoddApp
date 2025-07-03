//
//  UserDefaultManager.swift
//  OrderFoodApp
//
//  Created by Phincon on 04/10/24.
//

import Foundation


class AppSettings {
    static let shared = AppSettings()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    // Function untuk menyimpan nilai string ke UserDefaults
    func saveStringValue(_ value: String, forKey key: String) {
      UserDefaults.standard.set(value, forKey: key)
    }
    
    // Function untuk mengambil nilai string dari UserDefaults
    func getStringValue(forKey key: String) -> String? {
      return UserDefaults.standard.string(forKey: key)
    }
    
    var isFirstTime: Bool {
        get {
            return userDefaults.value(forKey: UserDefaultsKey.isFirstTime) as? Bool ?? true
        }
        set(_isNewDevice) {
            userDefaults.set(_isNewDevice, forKey: UserDefaultsKey.isFirstTime)
            userDefaults.synchronize()
        }
    }
    
    func rgbToHexString(red: CGFloat, green: CGFloat, blue: CGFloat) -> String {
        let redInt = Int(red * 255)
        let greenInt = Int(green * 255)
        let blueInt = Int(blue * 255)
        
        return String(format: "#%02X%02X%02X", redInt, greenInt, blueInt)
    }
    
}

class UserDefaultsKey {
    static let backgroundColor = "GeneralBackGroundColor"
    static let isFirstTime = "isFirstTime"
}
