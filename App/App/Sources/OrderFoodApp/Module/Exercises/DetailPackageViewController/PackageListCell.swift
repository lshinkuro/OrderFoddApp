//
//  PackageListCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 18/03/25.
//

import Foundation
import UIKit
import SnapKit

class PackageListCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        stackView.axis = .vertical
        stackView.spacing = 10
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(title: String, items: [(title: String, detail: String, price: String)]) {
        titleLabel.text = title
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // Hapus tampilan lama
        
        for item in items {
            let itemView = PackageItemView(title: item.title, detail: item.detail, price: item.price)
            stackView.addArrangedSubview(itemView)
        }
    }
}
