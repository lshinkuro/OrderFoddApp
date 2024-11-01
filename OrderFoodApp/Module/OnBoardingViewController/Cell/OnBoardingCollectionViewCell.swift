//
//  OnBoardingCollectionViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 04/10/24.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func setup(data: OnboardingItem?) {
        if let data = data {
            titleLabel.text = data.title
            imgView.image = data.image
        }
    }

}
