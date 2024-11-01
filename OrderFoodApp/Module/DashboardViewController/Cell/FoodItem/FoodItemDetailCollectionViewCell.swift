//
//  FoodItemDetailCollectionViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 01/10/24.
//

import UIKit

class FoodItemDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemFoodImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(data: FoodItem?) {
        guard let data = data else {
            return
        }
        titleLabel.text = data.name
        descriptionLabel.text = data.description
        itemFoodImage.image = UIImage(named: data.image)
        rating.text = String(data.rating)
        favoriteImage.image = UIImage(systemName: data.isFavorite ? "heart.fill" : "heart")
    }

}
