//
//  PendingTransactionCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/11/24.
//

import Foundation
import UIKit
import SnapKit

class PendingTransactionCell: UICollectionViewCell {
    static let reuseIdentifier = "PendingTransactionCell"
    
    private let containerView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let amountLabel = UILabel()
    private let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.backgroundColor = .systemPink.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 12
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [avatarImageView, nameLabel, amountLabel, statusLabel].forEach {
            containerView.addSubview($0)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview().inset(16)
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(amountLabel.snp.bottom).offset(4)
        }
    }
    
    func configure(with data: TransactionModel) {
        nameLabel.text = data.name
        amountLabel.text = data.type == .credit ? "+$\(data.amount)" : "-$\(data.amount)"
        statusLabel.text = data.status?.rawValue.capitalized
    }
}
