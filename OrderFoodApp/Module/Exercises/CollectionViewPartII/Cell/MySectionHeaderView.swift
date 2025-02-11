//
//  SectionHeaderView.swift
//  OrderFoodApp
//
//  Created by Phincon on 31/01/25.
//

import UIKit
import SnapKit

class MySectionHeaderView: UICollectionReusableView {
    static let identifier = "MySectionHeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }

    func configure(with title: String) {
        titleLabel.text = title
    }
}

