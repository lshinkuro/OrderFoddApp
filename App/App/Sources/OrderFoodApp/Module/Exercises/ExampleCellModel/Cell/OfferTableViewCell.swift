//
//  OfferTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 27/03/25.
//

import UIKit
import SnapKit

class OfferTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let discountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(discountLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
        }
        
        discountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
        }
    }
    
    func configure(with model: OfferModel) {
        titleLabel.text = model.title
        discountLabel.text = model.discount
    }
}
