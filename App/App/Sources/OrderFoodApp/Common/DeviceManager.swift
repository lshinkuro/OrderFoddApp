//
//  DeviceManager.swift
//  OrderFoodApp
//
//  Created by Phincon on 23/01/25.
//

import Foundation
import UIKit

class DeviceManager {
    // MARK: - Singleton Instance
    static let shared = DeviceManager()
    private init() {}

    // MARK: - Screen Dimensions
    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width

    // MARK: - iPhone Detection
    var isIphoneSE: Bool {
        return screenHeight <= 568.0 // iPhone SE (1st Gen)
    }

    var isIphone8AndBelow: Bool {
        return screenHeight <= 667.0 // iPhone 8 and smaller
    }

    var isIphoneXSeries: Bool {
        return screenHeight > 667.0 && screenHeight <= 812.0 // iPhone X, XS, 11 Pro
    }

    var isIphonePlusOrXR: Bool {
        return screenHeight > 812.0 && screenHeight <= 896.0 // iPhone XR, 11
    }

    var isIphone12OrNewer: Bool {
        return screenHeight > 896.0 // iPhone 12, 13, 14, Pro Max
    }

    // MARK: - iPad Detection
    var isIpadMini: Bool {
        return screenHeight > 1024.0 && screenHeight <= 1080.0
    }

    var isIpadStandard: Bool {
        return screenHeight > 1080.0 && screenHeight <= 1366.0
    }

    var isIpadPro: Bool {
        return screenHeight > 1366.0 // iPad Pro 12.9-inch
    }

    // MARK: - General Device Types
    var isIphone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    // MARK: - Dynamic Sizing Helper
    func sizeForDevice(
        small: CGFloat,
        medium: CGFloat,
        large: CGFloat,
        extraLarge: CGFloat = 0
    ) -> CGFloat {
        if isIphoneSE || isIpadMini {
            return small
        } else if isIphone8AndBelow || isIpadStandard {
            return medium
        } else if isIphoneXSeries || isIphonePlusOrXR {
            return large
        } else if isIphone12OrNewer || isIpadPro {
            return extraLarge > 0 ? extraLarge : large
        }
        return medium // Default fallback
    }
}
