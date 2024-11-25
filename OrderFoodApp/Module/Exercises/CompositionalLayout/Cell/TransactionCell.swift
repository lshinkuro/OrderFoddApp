//
//  TransactionCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/11/24.
//

import Foundation
import UIKit
import SnapKit

class TransactionCell: UICollectionViewCell {
    static let reuseIdentifier = "TransactionCell"
    
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let amountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [iconImageView, nameLabel, amountLabel].forEach {
            contentView.addSubview($0)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        amountLabel.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }
    }
    
    func configure(with data: TransactionModel) {
        nameLabel.text = data.name
        amountLabel.text = data.type == .credit ? "+$\(data.amount)" : "-$\(data.amount)"

        // Add icon loading logic here
    }
}
