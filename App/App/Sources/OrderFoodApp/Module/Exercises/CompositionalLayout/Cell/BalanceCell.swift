//
//  BalanceCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/11/24.
//

import Foundation
import UIKit
import SnapKit

class BalanceCell: UICollectionViewCell {
    static let reuseIdentifier = "BalanceCell"
    
    private let balanceLabel = UILabel()
    private let cardNumberLabel = UILabel()
    private let cardHolderLabel = UILabel()
    private let expiryLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 16
        
        [balanceLabel, cardNumberLabel, cardHolderLabel, expiryLabel].forEach {
            contentView.addSubview($0)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        cardNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(balanceLabel.snp.bottom).offset(20)
        }
        
        cardHolderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        
        expiryLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(with data: BalanceModel) {
        balanceLabel.text = "$\(data.amount)"
        cardNumberLabel.text = "•••• \(data.cardNumber.suffix(4))"
      }
}
