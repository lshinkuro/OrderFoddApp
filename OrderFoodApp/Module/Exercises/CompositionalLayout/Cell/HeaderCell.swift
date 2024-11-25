//
//  HeaderCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/11/24.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class HeaderCell: UICollectionViewCell {
    static let reuseIdentifier = "HeaderCell"
    
    private let nameLabel = UILabel()
    private let profileImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(profileImageView.snp.leading).offset(-10)
        }
    }
    
    func configure(with name: String, imageUrl: String) {
       nameLabel.text = "Hello \(name)"
       // Add image loading logic here (e.g., using Kingfisher or SDWebImage)
   }
}
