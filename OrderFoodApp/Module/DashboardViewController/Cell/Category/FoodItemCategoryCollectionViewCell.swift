//
//  FoodItemCategoryCollectionViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 01/10/24.
//

import UIKit

class FoodItemCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var subContainerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureData(item: FoodCategory) {
        imgView.image = UIImage(named: item.setImage())
        categoryLabel.text = item.rawValue
    }

}
