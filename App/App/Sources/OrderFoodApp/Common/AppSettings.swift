//
//  AppSettings.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import Foundation
import UIKit

enum SFSymbols {
    static let dashboardSymbol = UIImage(systemName: "house.fill")
    static let chartSymbol = UIImage(systemName: "chart.bar.doc.horizontal")
    static let historySymbol = UIImage(systemName: "clock.fill")
    static let profileSymbol = UIImage(systemName: "person.fill")

    static let statusSymbol = UIImage(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 8, weight: .regular, scale: .default))
}

enum ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}

extension CGFloat {
    static let currentDeviceWidth  = UIScreen.main.bounds.width
    static let currentDeviceHeight = UIScreen.main.bounds.height
}

// MARK: - View with tag
enum ConstantsTags {
    enum ViewTags {
        static let roundedHeader = 99
        static let grayArea = 100
        static let container = 101
    }
}


