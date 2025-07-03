//
//  Ext+bundle.swift
//  OrderFoodApp
//
//  Created by Phincon on 11/12/24.
//

import Foundation

extension Bundle {
    static var onLanguageChange: (() -> Void)?
    
    private static var bundle: Bundle?
    
    static func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else { return }
        bundle = Bundle(path: path)
        onLanguageChange?()
    }
    
    static func localizedString(key: String, comment: String = "") -> String {
        return bundle?.localizedString(forKey: key, value: nil, table: nil) ?? NSLocalizedString(key, comment: comment)
    }
}

private var associatedLanguageKey: UInt8 = 0

extension Bundle {
    static let swizzleLocalization: Void = {
        // Ganti Bundle default dengan custom behavior
        object_setClass(Bundle.main, LocalizedBundle.self)
    }()

    var currentLanguage: String? {
        get {
            objc_getAssociatedObject(self, &associatedLanguageKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &associatedLanguageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private class LocalizedBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        // Ambil path untuk bahasa yang dipilih
        guard let currentLanguage = Bundle.main.currentLanguage,
              let languagePath = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
              let localizedBundle = Bundle(path: languagePath) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return localizedBundle.localizedString(forKey: key, value: value, table: tableName)
    }
}
