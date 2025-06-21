//
//  PAckageItemView.swift
//  OrderFoodApp
//
//  Created by Phincon on 18/03/25.
//

import Foundation
import UIKit
import SnapKit


class PackageItemView: UIView {
    
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let priceLabel = UILabel()
    private let checkBox = UIButton(type: .system)
    
    init(title: String, detail: String, price: String) {
        super.init(frame: .zero)
        setupView()
        configure(title: title, detail: detail, price: price)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel, priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        addSubview(stackView)
        addSubview(checkBox)
        
        stackView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalTo(checkBox.snp.leading).offset(-10)
        }
        
        checkBox.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        checkBox.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        checkBox.addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
    }
    
    func configure(title: String, detail: String, price: String) {
        titleLabel.text = title
        detailLabel.text = detail
        priceLabel.text = price
    }
    
    @objc private func toggleCheck() {
        checkBox.isSelected.toggle()
    }
}
