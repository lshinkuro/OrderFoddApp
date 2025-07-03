//
//  HeadlineAndDescriptionCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 24/01/25.
//

import UIKit
import SnapKit

class HeadlineAndDescriptionCell: UITableViewCell {
    static let identifier = "HeadlineAndDescriptionCell"
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeadlineAndDescriptionCell {
    private func setupUI() {
        contentView.addSubview(headlineLabel)
        contentView.addSubview(descriptionLabel)
        
        headlineLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(headlineLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(headline: String, description: String) {
        headlineLabel.text = headline
        descriptionLabel.text = description
    }
}
