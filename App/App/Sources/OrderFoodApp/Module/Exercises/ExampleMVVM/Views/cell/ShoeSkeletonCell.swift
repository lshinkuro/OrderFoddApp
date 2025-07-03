//
//  ShoeSkeletonCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 15/03/25.
//

import UIKit
import SkeletonView

class ShoeSkeletonCell: UITableViewCell {

    
    @IBOutlet var views: [UIView]!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        
        views.forEach {
            $0.isSkeletonable = true
            $0.showAnimatedGradientSkeleton()
        }
    }
    
    
}
