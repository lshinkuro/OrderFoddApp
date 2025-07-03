//
//  ExampleGridList.swift
//  OrderFoodApp
//
//  Created by Phincon on 02/12/24.
//

import Foundation
import UIKit
import SnapKit


struct ProductSection {
    var title: String
    var items: [ProductItem]
}

struct ProductItem {
    var name: String
    var icon: String
}

class ExampleGridListViewController: BaseViewController {
    
    private var collectionView: UICollectionView!
    
    
    private var isGridMode = true // Default to Grid Mode
    private var sections: [ProductSection] = [
        ProductSection(title: "Transportasi", items: [
            ProductItem(name: "Taksi", icon: "car"),
            ProductItem(name: "Kereta Api", icon: "train"),
            ProductItem(name: "Bus ", icon: "bus")

        ]),
        ProductSection(title: "Akomodasi", items: [
            ProductItem(name: "Hotel Budget", icon: "house"),
            ProductItem(name: "Villa", icon: "building"),
            ProductItem(name: "Motel", icon: "house.fill"),
            ProductItem(name: "Kos", icon: "heart.fill")

        ]),
        ProductSection(title: "Atraksi", items: [
            ProductItem(name: "Spa & Kecantikan", icon: "flower"),
            ProductItem(name: "Taman Bermain", icon: "park")
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let toggleButton = UISegmentedControl(items: ["Grid", "List"])
        toggleButton.selectedSegmentIndex = 0
        toggleButton.addTarget(self, action: #selector(toggleMode), for: .valueChanged)
        view.addSubview(toggleButton)
        toggleButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
        
        // Collection View
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50) // Header size
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GridCell.self, forCellWithReuseIdentifier: "GridCell")
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: "ListCell")
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderView")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(toggleButton.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc private func toggleMode(_ sender: UISegmentedControl) {
          isGridMode = sender.selectedSegmentIndex == 0
          collectionView.reloadData()
      }
}

extension ExampleGridListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
           return sections.count
       }

       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return sections[section].items.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let item = sections[indexPath.section].items[indexPath.item]
           if isGridMode {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell
               cell.configure(with: item)
               return cell
           } else {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! ListCell
               cell.configure(with: item)
               return cell
           }
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           if isGridMode {
               let width = (collectionView.frame.width - 30) / 3 // 3 items per row
               return CGSize(width: width, height: width)
           } else {
               return CGSize(width: collectionView.frame.width - 20, height: 60)
           }
       }

       // Header Configuration
       func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
           if kind == UICollectionView.elementKindSectionHeader {
               let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
               header.configure(with: sections[indexPath.section].title)
               return header
           }
           return UICollectionReusableView()
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
           return CGSize(width: collectionView.frame.width, height: 50)
       }
}


// MARK: - Section Header View
class SectionHeaderView: UICollectionReusableView {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }

    func configure(with title: String) {
        titleLabel.text = title
    }
}

// MARK: - Grid Cell
class GridCell: UICollectionViewCell {
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        iconImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(40)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.textAlignment = .center
    }

    func configure(with item: ProductItem) {
        iconImageView.image = UIImage(systemName: item.icon)
        nameLabel.text = item.name
    }
}

// MARK: - List Cell
class ListCell: UICollectionViewCell {
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        iconImageView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        nameLabel.font = .systemFont(ofSize: 16)
    }

    func configure(with item: ProductItem) {
        iconImageView.image = UIImage(systemName: item.icon)
        nameLabel.text = item.name
    }
}
