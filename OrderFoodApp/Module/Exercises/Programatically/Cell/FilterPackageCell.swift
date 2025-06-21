//
//  FilterPackageCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/03/25.
//

import UIKit
import SnapKit

class FilterPackageCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var isMultipleSelection = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    func configure(with title: String, isSelected: Bool, isMultiple: Bool) {
        titleLabel.text = title
        isMultipleSelection = isMultiple
        checkmarkImageView.image = isSelected ? (isMultiple ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "largecircle.fill.circle")) : nil
    }
}
