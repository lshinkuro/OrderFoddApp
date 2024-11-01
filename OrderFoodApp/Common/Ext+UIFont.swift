//
//  Ext+UIFont.swift
//  OrderFoodApp
//
//  Created by Phincon on 05/10/24.
//

import Foundation
import UIKit

extension UIFont {
    
    static func foodBrownie(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: "BrownieStencil",
            size: size) ?? .systemFont(ofSize: size)
    }
    
    static func foodNatureBeauty(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: "NatureBeautyPersonalUse",
            size: size) ?? .systemFont(ofSize: size)
    }
    
    static func foodBold(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: "OpenSans-Bold",
            size: size) ?? .systemFont(ofSize: size)
    }
    
    static func foodBoldItalic(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: "OpenSans-BoldItalic",
            size: size) ?? .systemFont(ofSize: size)
    }
    
    static func foodCondBold(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: "OpenSans-CondBold",
            size: size) ?? .systemFont(ofSize: size)
    }
    
    static func foodCondLight(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: "OpenSans-CondLight",
            size: size) ?? .systemFont(ofSize: size)
    }
    
    static func foodCondLightItalic(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: "OpenSans-CondLightItalic",
            size: size) ?? .systemFont(ofSize: size)
    }
    
    static func foodExtraBold(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: "OpenSans-ExtraBold",
            size: size) ?? .systemFont(ofSize: size)
    }
    
    static func foodExtraBoldItalic(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: "OpenSans-ExtraBoldItalic",
            size: size) ?? .systemFont(ofSize: size)
    }
    
    static func foodItalic(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: "OpenSans-Italic",
            size: size) ?? .systemFont(ofSize: size)
    }
    
    static func foodLight(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: "OpenSans-Light",
            size: size) ?? .systemFont(ofSize: size)
    }
    
    static func foodLightItalic(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: "OpenSans-LightItalic",
            size: size) ?? .systemFont(ofSize: size)
    }
    
    static func foodRegular(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: "OpenSans-Regular",
            size: size) ?? .systemFont(ofSize: size)
    }
    
    static func foodSemiBold(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: "OpenSans-SemiBold",
            size: size) ?? .systemFont(ofSize: size)
    }
    
    static func foodSemiBoldItalic(_ size: CGFloat) -> UIFont {
        return UIFont(
            name: "OpenSans-SemiBoldItalic",
            size: size) ?? .systemFont(ofSize: size)
    }
    
}
