//
//  PackageItemView.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/03/25.
//

import UIKit
import SnapKit

class PackageItemListView: UIView {
    private let iconImageView = UIImageView()
    
    private let titleLabel = UILabel().configure {
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    private let subtitleLabel = UILabel().configure {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.numberOfLines = 0
    }
    
    private let valueLabel = UILabel().configure {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemRed
        $0.setContentHuggingPriority(.required, for: .horizontal) // Hindari terlalu melebar
    }
    
    init(item: PackageItem) {
        super.init(frame: .zero)
        setupView()
        configure(with: item)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        iconImageView.contentMode = .scaleAspectFit
        
        let hStack = UIStackView(arrangedSubviews: [iconImageView, titleLabel, valueLabel])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .center
        hStack.distribution = .fill // Pastikan title tidak terjepit oleh value
        
        let vStack = UIStackView(arrangedSubviews: [hStack, subtitleLabel])
        vStack.axis = .vertical
        vStack.spacing = 4
        
        addSubview(vStack)
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        vStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8) // Tambahkan padding agar tidak mentok
        }
    }
    
    private func configure(with item: PackageItem) {
        iconImageView.image = UIImage(systemName: item.iconName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        valueLabel.text = item.value
    }
}

struct PackageItem {
    let iconName: String
    let title: String
    let subtitle: String?
    let value: String
}
