//
//  SpecialItemTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 31/10/24.
//

import UIKit

class SpecialItemTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
