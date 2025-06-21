//
//  Common.swift
//  OrderFoodApp
//
//  Created by Phincon on 22/10/24.
//

import Foundation
import UIKit

class Common {
    
    static let shared = Common()
    
    private init() {}
    
    
    /// Add subview to super window
    /// - Parameter window: a call back if super window is not nil
    func addViewToWindow(window: (UIWindow) -> Void) {
        let currentWindow = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        if let activeWindow = currentWindow {
            window(activeWindow)
        }
    }
}

import Foundation

public protocol Configurable {}

extension NSObject: Configurable {}

public extension Configurable where Self: AnyObject {
    @discardableResult
    func configure(_ transform: (Self) -> Void) -> Self {
        transform(self)
        return self
    }
}

