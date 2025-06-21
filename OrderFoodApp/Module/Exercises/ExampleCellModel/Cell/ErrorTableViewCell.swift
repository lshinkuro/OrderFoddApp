//
//  ErrorTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 27/03/25.
//

import UIKit
import SnapKit

class ErrorTableViewCell: UITableViewCell {
    private let errorLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(errorLabel)
        errorLabel.text = "Error loading data"
        errorLabel.textColor = .red

        errorLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
