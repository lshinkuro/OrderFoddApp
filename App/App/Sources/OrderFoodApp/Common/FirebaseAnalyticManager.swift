//
//  FirebaseAnalyticManager.swift
//  OrderFoodApp
//
//  Created by Phincon on 24/10/24.
//

import Foundation
import FirebaseAnalytics

class FAM {
    static let shared = FAM()
    
    private init() {} // Prevents others from using the default '()' initializer

    func logButtonEvent(buttonName: String, screenName: String) {
        Analytics.logEvent(FAE.buttonPressed, parameters: [
            "button_name": buttonName as NSObject,
            "screen_name": screenName as NSObject
        ])
    }
}

enum FAE {
    static let buttonPressed = "button_pressed"
    static let sectionClick = "section_click"
    static let cardClick = "card_click"
    static let switchClick = "switch_click"
}
