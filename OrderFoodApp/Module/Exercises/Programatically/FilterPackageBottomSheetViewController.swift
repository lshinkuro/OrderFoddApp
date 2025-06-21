//
//  FilterPackageBottomSheetViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/03/25.
//

import UIKit
import RxSwift

enum FilterPackageType {
    case single
    case multiple
}

struct FilterCategory {
    let title: String
    let type: FilterPackageType
    let options: [String]
}


class FilterPackageBottomSheetViewController: UIViewController {

    
    @IBOutlet weak var tabCollectionView: UICollectionView!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    public var heightFPC = CustomObservable<CGFloat>()
    
    var filterCategories: [FilterCategory] = [
        FilterCategory(title: "Kategori 1", type: .single, options: ["Option 1", "Option 2", "Option 3"]),
        FilterCategory(title: "Kategori 2", type: .multiple, options: ["Option A", "Option B", "Option C", "Option D", "Option E", "Option F"])
    ]
    
    var selectedCategoryIndex = 0 // Menyimpan index tab yang sedang dipilih

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateTableViewHeight()

    }
    
    private func getHeightOfViewController() -> CGFloat {
        return heightTableView.constant + 100
    }
    
    func setup() {
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.register(TabCollectionCell.self, forCellWithReuseIdentifier: "TabCollectionCell")
        
        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.register(FilterPackageCell.self, forCellReuseIdentifier: "FilterPackageCell")
    }
    

}

extension FilterPackageBottomSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCollectionCell", for: indexPath) as! TabCollectionCell
        cell.configure(with: filterCategories[indexPath.row].title, isSelected: indexPath.item == selectedCategoryIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.item
        filterTableView.reloadData()
        updateTableViewHeight()
        collectionView.reloadData()
    }
}

extension FilterPackageBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCategories[selectedCategoryIndex].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FilterPackageCell

        let filter = filterCategories[selectedCategoryIndex].options[indexPath.row]
        
        let isSingleSelection = filterCategories[selectedCategoryIndex].type == .single
        cell.textLabel?.text = filter
        cell.accessoryType = isSingleSelection ? .none : .checkmark // Ubah ke radio button sesuai kebutuhan
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filterCategories[selectedCategoryIndex].type == .single {
            tableView.visibleCells.forEach { $0.accessoryType = .none }
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func updateTableViewHeight() {
        let itemCount = filterCategories[selectedCategoryIndex].options.count
        heightTableView.constant = CGFloat(itemCount * 44) // 44 adalah tinggi default UITableViewCell
        heightFPC.observer = getHeightOfViewController()
    }

}

