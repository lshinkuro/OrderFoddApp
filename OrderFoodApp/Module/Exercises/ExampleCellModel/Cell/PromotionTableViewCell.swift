//
//  PromotionTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 27/03/25.
//

import UIKit
import SnapKit

class PromotionTableViewCell: UITableViewCell {
    private let bannerImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(bannerImageView)

        bannerImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
            make.height.equalTo(120)
        }
    }

    func configure(with model: PromotionModel) {
        bannerImageView.image = UIImage(named: model.bannerImage)
    }
}
