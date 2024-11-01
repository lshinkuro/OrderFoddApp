//
//  Ext+UIView.swift
//  OrderFoodApp
//
//  Created by Phincon on 01/10/24.
//

import Foundation
import UIKit

extension UIView {
    
    func add(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }

    
    func getViewController() -> UIViewController? {
         var nextResponder: UIResponder? = self
         while nextResponder != nil {
             nextResponder = nextResponder?.next
             if let viewController = nextResponder as? UIViewController {
                 return viewController
             }
         }
         return nil
     }
}
