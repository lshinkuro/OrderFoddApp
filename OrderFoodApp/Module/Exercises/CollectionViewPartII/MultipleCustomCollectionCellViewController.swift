//
//  MultipleCustomCollectionCellViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 31/01/25.
//

import UIKit
import SnapKit

class MultipleCustomCollectionCellViewController: UIViewController {

    private var collectionView: UICollectionView!
    private var categories: [FoodCategoryModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupCollectionView()
    }

    private func setupData() {
        categories = [
            FoodCategoryModel(name: "Kategori Makanan", foods: [
                Food(name: "Pizza", imageName: "pizza", price: "Rp 50.000"),
                Food(name: "Burger", imageName: "burger", price: "Rp 35.000"),
                Food(name: "Sushi", imageName: "sushi", price: "Rp 75.000")
            ]),
            FoodCategoryModel(name: "Makanan Populer", foods: [
                Food(name: "Pasta", imageName: "pasta", price: "Rp 45.000"),
                Food(name: "Steak", imageName: "steak", price: "Rp 120.000"),
                Food(name: "Salad", imageName: "salad", price: "Rp 30.000")
            ]),
            FoodCategoryModel(name: "Rekomendasi Hari Ini", foods: [
                Food(name: "Nasi Goreng", imageName: "nasi_goreng", price: "Rp 25.000"),
                Food(name: "Ayam Bakar", imageName: "ayam_bakar", price: "Rp 40.000"),
                Food(name: "Es Teh", imageName: "es_teh", price: "Rp 10.000")
            ])
        ]
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(FoodCollectionCell.self, forCellWithReuseIdentifier: FoodCollectionCell.identifier)
        collectionView.register(MySectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MySectionHeaderView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MultipleCustomCollectionCellViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].foods.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionCell.identifier, for: indexPath) as! FoodCollectionCell
        let food = categories[indexPath.section].foods[indexPath.row]
        cell.configure(with: food)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MySectionHeaderView.identifier, for: indexPath) as! MySectionHeaderView
            header.configure(with: categories[indexPath.section].name)
            return header
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2) - 24, height: 180)
    }
}

