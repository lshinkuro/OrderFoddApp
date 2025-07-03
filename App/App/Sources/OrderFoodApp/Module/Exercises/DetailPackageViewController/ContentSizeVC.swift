//
//  ContentSizeVC.swift
//  OrderFoodApp
//
//  Created by Phincon on 18/03/25.
//

import Foundation
import UIKit
import SnapKit

class ContentSizeVC: UIViewController {

    // MARK: - Properties
    private let tableView = UITableView()
    private let tabControl = UISegmentedControl(items: ["Tab 1", "Tab 2"])
    private var data: [[String]] = [
        ["Cell 1", "Cell 2", "Cell 3"],
        ["Nested Cell 1", "Nested Cell 2"]
    ]
    
    private let packages: [(title: String, items: [(title: String, detail: String, price: String)])] = [
         ("Beli sekaligus, Lebih Hemat", [
             ("Carry Over Kuota", "10 GB | 30 Hari", "+Rp5.000"),
             ("Internet OMG! Ekstra", "5 GB | 30 Hari", "+Rp5.000"),
             ("YouTube 3.5 GB", "2.5 GB | 7 Hari", "+Rp25.000"),
             ("FreeFire Diamond", "77 Diamond | 7 Hari", "+Rp20.000"),
             ("Mobile Security", "2.5 GB | 7 Hari", "+Rp5.000")
         ])
     ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        // Setup Tab Control
        tabControl.selectedSegmentIndex = 0
        tabControl.addTarget(self, action: #selector(tabChanged), for: .valueChanged)
        view.addSubview(tabControl)
        tabControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // Setup TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustumTableViewCell.self, forCellReuseIdentifier: "CustumTableViewCell")
        tableView.register(PackageListCell.self, forCellReuseIdentifier: "PackageListCell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tabControl.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    @objc private func tabChanged() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ContentSizeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return data[tabControl.selectedSegmentIndex].count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustumTableViewCell", for: indexPath) as! CustumTableViewCell
            cell.configure(with: data[tabControl.selectedSegmentIndex][indexPath.row])
            return cell
        case 1:
            return self.createPackageCell(indexPath: indexPath, tableView: tableView)

        default:
            return UITableViewCell()
        }
        
     
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func createPackageCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PackageListCell", for: indexPath) as? PackageListCell else {
                   return UITableViewCell()
               }
               let package = packages[indexPath.row]
               cell.configure(title: package.title, items: package.items)
               return cell
    }
}

class CustumTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        return cv
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
    }
    
    // MARK: - Configuration
    func configure(with title: String) {
        titleLabel.text = title
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension CustumTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 // Jumlah item di dalam collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        cell.backgroundColor = .lightGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}
