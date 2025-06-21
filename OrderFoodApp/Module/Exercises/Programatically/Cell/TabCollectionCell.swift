//
//  TabCollectionCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/03/25.
//

import UIKit
import SnapKit

class TabCollectionCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        contentView.backgroundColor = isSelected ? .blue : .white
        titleLabel.textColor = isSelected ? .white : .black
    }
}
