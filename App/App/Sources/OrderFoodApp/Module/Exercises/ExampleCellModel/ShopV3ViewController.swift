//
//  ShopV3ViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 27/03/25.
//

import UIKit
import RxSwift
import SnapKit

class ShopV3ViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel = ShopV3ViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        ShopV3Section.allCellTypes().forEach { cellType, identifier in
            tableView.register(cellType, forCellReuseIdentifier: identifier)
        }
    }
    
    private func bindViewModel() {
        viewModel.dataSource
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension ShopV3ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.dataSource.value[indexPath.section][indexPath.row]
        
        switch cellType {
        case .offer(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "OfferCell", for: indexPath) as! OfferTableViewCell
            cell.configure(with: model)
            return cell
        case .product(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
            cell.configure(with: model)
            return cell
        case .promotion(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionCell", for: indexPath) as! PromotionTableViewCell
            cell.configure(with: model)
            return cell
        case .skeleton:
            return tableView.dequeueReusableCell(withIdentifier: "SkeletonCell", for: indexPath)
        case .error:
            return tableView.dequeueReusableCell(withIdentifier: "ErrorCell", for: indexPath)
        }
    }
}
