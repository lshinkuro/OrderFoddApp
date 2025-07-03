//
//  AdsFoodTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 03/10/24.
//

import UIKit

class AdsFoodTableViewCell: UITableViewCell {

    @IBOutlet weak var adsLabel: UILabel!
    @IBOutlet weak var adsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(data: AdsFoodData?) {
        if let item = data {
            adsLabel.text = item.name
            adsImage.image = UIImage(named: item.image)
        }
    }
    
}
