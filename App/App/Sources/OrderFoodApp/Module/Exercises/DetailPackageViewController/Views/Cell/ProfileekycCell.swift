//
//  ProfileekycCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 19/03/25.
//

import UIKit
import SnapKit
import RxSwift



class ProfileekycCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.addShadowToView()
        view.drawDottedBorder()
        return view
    }()
    
    let labelDescription: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView = UIStackView().configure {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(containerView)
        contentView.backgroundColor = .clear
        
        containerView.add(labelDescription, stackView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        labelDescription.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(labelDescription.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    
    func configure(text: String, with rows: [UIView]) {
        labelDescription.text = text
        // Bersihkan stackView sebelum menambahkan elemen baru
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        rows.forEach { stackView.addArrangedSubview($0) }
    }
    
    
}
