//
//  RoundedHeader.swift
//  OrderFoodApp
//
//  Created by Phincon on 05/10/24.
//

import UIKit

class RoundedHeader: UIImageView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        makeCornerRadius(24, maskedCorner: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        contentMode = .scaleAspectFill
        tag = ConstantsTags.ViewTags.roundedHeader
    }
}
