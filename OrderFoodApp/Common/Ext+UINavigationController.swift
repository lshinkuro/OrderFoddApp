//
//  Ext+UINavigationController.swift
//  OrderFoodApp
//
//  Created by Phincon on 13/03/25.
//

import UIKit

extension UINavigationController {
    func pushFromBottom(_ viewController: UIViewController, animated: Bool = true) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromTop  // Animasi dari bawah ke atas

        self.view.layer.add(transition, forKey: kCATransition)
        self.pushViewController(viewController, animated: false) // `false` agar tidak double animasi
    }
}

