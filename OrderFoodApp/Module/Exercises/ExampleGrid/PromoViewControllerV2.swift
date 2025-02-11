//
//  PromoViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/01/25.
//

import Foundation
import UIKit
import SnapKit

// MARK: - Models
struct PromoItem {
    let title: String
    let subtitle: String
    let price: String
    let duration: String
    let isHotPromo: Bool
    let imageUrl: String?
}

// MARK: - Collection View Cell
class PromoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PromoCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let hotPromoLabel: UILabel = {
        let label = UILabel()
        label.text = "Hot Promo"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.backgroundColor = .systemRed
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
//        label.padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
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
        contentView.addSubview(containerView)
        containerView.addSubview(hotPromoLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(durationLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        hotPromoLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(hotPromoLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalTo(priceLabel)
        }
    }
    
    func configure(with item: PromoItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        priceLabel.text = item.price
        durationLabel.text = item.duration
        hotPromoLabel.isHidden = !item.isHotPromo
    }
}

// MARK: - View Controller
class PromoViewControllerV2: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PromoCollectionViewCell.self, forCellWithReuseIdentifier: PromoCollectionViewCell.identifier)
        return collectionView
    }()
    
    private var items: [PromoItem] = [
        PromoItem(title: "Internet", subtitle: "7GB", price: "Rp20.000", duration: "5 Hari", isHotPromo: true, imageUrl: nil),
        PromoItem(title: "Internet", subtitle: "30GB", price: "Rp59.000", duration: "30 Hari", isHotPromo: false, imageUrl: nil)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension PromoViewControllerV2: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromoCollectionViewCell.identifier, for: indexPath) as? PromoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 24) / 2 // 2 columns with spacing
        return CGSize(width: width, height: 160)
    }
}
