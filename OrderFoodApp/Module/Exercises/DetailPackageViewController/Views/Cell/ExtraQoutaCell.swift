//
//  ExtraQoutaCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/03/25.
//

import UIKit
import SnapKit

class ExtraQuotaCell: UITableViewCell {
    
    static let reuseIdentifier = "ExtraQuotaCell"
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.drawDottedBorder()
        return view
    }()

    private let iconImageView = UIImageView().configure {
        $0.image = UIImage(systemName: "globe") // Ganti dengan icon sesuai kebutuhan
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
    }
    
    
    private let titleLabel = UILabel().configure {
        $0.font = .boldSystemFont(ofSize: 16)

    }
    private let subtitleLabel = UILabel().configure {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.numberOfLines = 0
    }
    
    private let quotaLabel = UILabel().configure {
        $0.text = "1 GB"
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    private let textStackView: UIStackView = UIStackView().configure{
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    private let mainStackView: UIStackView = UIStackView().configure {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.alignment = .center
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        titleLabel.text = "Nonton"
        subtitleLabel.text = "Dapat menggunakan internet lain saat kuota nonton habis."

        textStackView.addStack(titleLabel, subtitleLabel)
        mainStackView.addStack(iconImageView, textStackView, quotaLabel)
        containerView.addSubview(mainStackView)
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(with title: String, subtitle: String, quota: String, icon: UIImage?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        quotaLabel.text = quota
        iconImageView.image = icon
    }
}
