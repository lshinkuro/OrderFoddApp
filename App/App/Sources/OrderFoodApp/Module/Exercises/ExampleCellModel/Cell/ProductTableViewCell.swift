//
//  Untitled.swift
//  OrderFoodApp
//
//  Created by Phincon on 27/03/25.
//

import UIKit
import SnapKit

class ProductTableViewCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)

        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
        }
    }

    func configure(with model: ProductModel) {
        nameLabel.text = model.name
        priceLabel.text = model.price
    }
}
