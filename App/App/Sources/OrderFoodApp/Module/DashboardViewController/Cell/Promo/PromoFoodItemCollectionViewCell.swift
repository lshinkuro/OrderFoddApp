//
//  PromoFoodItemCollectionViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 02/10/24.
//

import UIKit

class PromoFoodItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.addShadowToView()
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
    }
    
    func setup(data: PromoFoodData) {
        imgView.image = UIImage(named: data.image)
    }

}
