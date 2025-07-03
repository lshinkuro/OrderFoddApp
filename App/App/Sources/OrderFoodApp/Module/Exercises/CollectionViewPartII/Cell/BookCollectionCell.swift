//
//  BookCollectionCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 31/01/25.
//

import UIKit
import SnapKit

class BookCollectionCell: UICollectionViewCell {
    static let identifier = "BookCollectionCell"
    
    // UI Components
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    // Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension BookCollectionCell {
    // Setup UI
    private func setupUI() {
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        
        coverImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    // Configure cell with data
    func configure(with book: Book) {
        coverImageView.image = UIImage(named: book.coverImageName)
        titleLabel.text = book.title
        authorLabel.text = book.author
    }
}


