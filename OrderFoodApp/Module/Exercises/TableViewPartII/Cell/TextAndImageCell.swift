//
//  TextAndImageCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 24/01/25.
//

import UIKit
import SnapKit

class TextAndImageCell: UITableViewCell {
    static let identifier = "TextAndImageCell"
    
    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
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

extension TextAndImageCell {
    private func setupUI() {
        contentView.addSubview(customImageView)
        contentView.addSubview(titleLabel)
        
        customImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
            make.size.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(customImageView)
            make.left.equalTo(customImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
        }
    }
    
    func configure(image: UIImage?, title: String) {
        customImageView.image = image
        titleLabel.text = title
    }
}


