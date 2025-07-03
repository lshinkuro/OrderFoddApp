//
//  GeneralSkeletonTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 31/10/24.
//

import UIKit
import SkeletonView

class GeneralSkeletonTableViewCell: UITableViewCell {
    
    @IBOutlet private var topStackConstraint: NSLayoutConstraint!
    @IBOutlet private var categoryStack: UIView!
    @IBOutlet private var numbersView: [UIView]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {
        topStackConstraint.constant = 20
        self.layoutIfNeeded()
        
        for view in numbersView {
            view.isSkeletonable = true
            view.layer.backgroundColor = UIColor.red.cgColor
            view.layer.cornerRadius = 15
            
        }
    }
    
}
