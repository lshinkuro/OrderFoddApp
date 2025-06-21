//
//  SkeletonTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 27/03/25.
//

import UIKit


class SkeletonTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
