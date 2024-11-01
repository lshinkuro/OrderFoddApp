//
//  Ext+UIStackview.swift
//  OrderFoodApp
//
//  Created by Phincon on 22/10/24.
//

import Foundation
import UIKit

extension UIStackView {
    func addStack(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
