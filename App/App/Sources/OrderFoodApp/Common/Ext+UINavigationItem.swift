//
//  Ext+UINavigationItem.swift
//  OrderFoodApp
//
//  Created by Phincon on 05/10/24.
//

import Foundation
import UIKit


extension UINavigationItem {
    func setTitleNav(title: String? = "", subtitle: String? = "") {
        
        let one = UILabel()
        one.text = title
        one.font = .foodBold(18)
        one.textColor = .foodWhite100
        one.textAlignment = .center
        one.sizeToFit()
            
        let two = UILabel()
        two.text = subtitle
        two.font = .foodSemiBold(12)
        two.textAlignment = .left
        two.textColor = .foodGrey5
        two.sizeToFit()
            
        let stackView = UIStackView(arrangedSubviews: [one, two])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
            
        let width = max(one.frame.size.width, two.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 50)
            
        one.sizeToFit()
        two.sizeToFit()
    
        titleView = stackView
    }
}
