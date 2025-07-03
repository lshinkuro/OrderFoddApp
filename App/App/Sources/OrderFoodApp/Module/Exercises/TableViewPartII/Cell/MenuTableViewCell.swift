//
//  MenuTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 24/01/25.
//

import Foundation
import UIKit
import SnapKit

class MenuTableViewCell: UITableViewCell {
    static let identifier = "MenuTableViewCell"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var items: [String] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuTableViewCell {
    private func setupUI() {
        contentView.addSubview(collectionView)
        
        collectionView.register(ItemCollectionViewCell.self,
                                forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(items: [String]) {
        self.items = items
        collectionView.reloadData()
    }
}

extension MenuTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier,
                                                            for: indexPath) as? ItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(text: items[indexPath.row])
        return cell
    }
}

