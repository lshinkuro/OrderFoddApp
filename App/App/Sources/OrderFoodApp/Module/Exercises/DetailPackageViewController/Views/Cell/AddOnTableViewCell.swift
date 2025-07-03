//
//  AddOnTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/03/25.
//

import Foundation
import UIKit
import SnapKit


// MARK: - Add-On TableViewCell
class AddOnTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "AddOnTableViewCell"
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - UI Components
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        }

    }
    
    
    func configure(with dataRows: [AddOnItem]) {
        // Bersihkan stackView sebelum menambahkan elemen baru
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        dataRows.enumerated().forEach { index, item in
            let contentView = AddOnContentView(with: item)
            stackView.addArrangedSubview(contentView)
            
            if index == dataRows.count - 1 {
                contentView.separatorView.isHidden = true
            }
            
            // Apply constraints after adding to stackView
            contentView.snp.makeConstraints { make in
                // You don't need to set width constraints for arranged subviews
                
                // Set a minimum height
                make.height.greaterThanOrEqualTo(60)
            }
        }
    }
}
