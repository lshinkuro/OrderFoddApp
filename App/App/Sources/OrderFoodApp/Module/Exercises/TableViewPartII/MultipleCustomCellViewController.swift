//
//  MultipleCustomCellViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 24/01/25.
//

import UIKit
import SnapKit

class MultipleCustomCellViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    // Data untuk setiap section
    private let data: [[CellType]] = [
        [
            .textAndImage(image: UIImage(systemName: "star"), title: "Apple"),
            .textAndImage(image: UIImage(systemName: "flame"), title: "Orange")
        ],
        [
            .headlineAndDescription(headline: "Vegetables", description: "Healthy vegetables like carrot, broccoli, spinach."),
            .headlineAndDescription(headline: "Fruits", description: "Sweet fruits like apple and banana.")
        ],
        [] // Section untuk Collection View
    ]
    
    private let collectionViewData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Multiple Custom Cells"
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TextAndImageCell.self, forCellReuseIdentifier: TextAndImageCell.identifier)
        tableView.register(HeadlineAndDescriptionCell.self, forCellReuseIdentifier: HeadlineAndDescriptionCell.identifier)
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}



extension MultipleCustomCellViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].isEmpty ? 1 : data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = data[indexPath.section]
        
        if sectionData.isEmpty {
            // Section untuk Collection View
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MenuTableViewCell
            cell.configure(items: collectionViewData)
            return cell
        }
        
        let cellData = sectionData[indexPath.row]
        switch cellData {
        case .textAndImage(let image, let title):
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TextAndImageCell
            cell.configure(image: image, title: title)
            return cell
            
        case .headlineAndDescription(let headline, let description):
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HeadlineAndDescriptionCell
            cell.configure(headline: headline, description: description)
            return cell
        }
    }
}



extension MultipleCustomCellViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionData = data[indexPath.section]
        
        if sectionData.isEmpty {
            return 150 // Tinggi untuk Collection View Cell
        }
        
        let cellData = sectionData[indexPath.row]
        switch cellData {
        case .textAndImage:
            return 80
        case .headlineAndDescription:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Text and Image Section"
        case 1: return "Headline and Description Section"
        case 2: return "Collection View Section"
        default: return nil
        }
    }
}

enum CellType {
    case textAndImage(image: UIImage?, title: String)
    case headlineAndDescription(headline: String, description: String)
}

