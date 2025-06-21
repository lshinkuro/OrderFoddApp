//
//  ShoeListViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 21/01/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ShoeListViewController: BaseViewController {
    
    private let tableView = UITableView()
    private let loadingLabel = UILabel()
    private let emptyLabel = UILabel()
    private let errorLabel = UILabel()
    
    private let viewModel = ShoeListViewModel()
    var shoeItems: [ShoeItem] = []
    private var isSectionVisible = true // State untuk menyimpan status section
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchShoeItems()
    }
    
    private func setupUI() {
        title = "Shoe List"
        view.backgroundColor = .white
        
        loadingLabel.text = "Loading..."
        loadingLabel.textAlignment = .center
        loadingLabel.isHidden = true
        
        emptyLabel.text = "No items available."
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true
        
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ShoeCell")
        tableView.registerCellWithNib(ShoeSkeletonCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(loadingLabel)
        view.addSubview(emptyLabel)
        view.addSubview(errorLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupBindings() {
        viewModel.shoeItems
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] items in
                    guard let self = self else { return }
                    self.shoeItems = items
                    self.tableView.reloadData()
                },
                onError: { error in
                    print("RxSwift Error: \(error.localizedDescription)")
                }
            ).disposed(by: disposeBag)
        
        
        
        //        tableView.rx.modelSelected(ShoeItem.self)
        //            .subscribe(onNext: { [weak self] item in
        //                let detailVC = ShoeDetailViewController(viewModel: ShoeDetailViewModel(shoeItem: item))
        //                self?.navigationController?.pushViewController(detailVC, animated: true)
        //            })
        //            .disposed(by: disposeBag)
    }
    
    private func updateUI(for state: DataState) {
        loadingLabel.isHidden = true
        emptyLabel.isHidden = true
        errorLabel.isHidden = true
        tableView.isHidden = true
        
        switch state {
        case .loading:
            loadingLabel.isHidden = false
        case .success:
            tableView.isHidden = false
        case .empty:
            emptyLabel.isHidden = false
        case .error(let message):
            errorLabel.isHidden = false
            errorLabel.text = "Error: \(message)"
        }
    }
}

extension ShoeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSectionVisible ? shoeItems.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if shoeItems.isEmpty {
            // Jika masih loading atau tidak ada data, tampilkan skeleton
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShoeSkeletonCell", for: indexPath) as! ShoeSkeletonCell
            return cell
        } else {
            // Jika data tersedia, gunakan UITableViewCell standar
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShoeCell", for: indexPath)
            let item = shoeItems[indexPath.row]
            cell.textLabel?.text = item.name
            cell.accessoryType = item.isFavorite ? .checkmark : .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ShoeListHeaderView()
        headerView.configure(title: "Shoe Collection", isExpanded: isSectionVisible)
        if section == 0 {
            headerView.onTapImage = { [weak self] in
                guard let self = self else { return }
                
                self.isSectionVisible.toggle() // Toggle state
                            
                // Tetap reload section tanpa animasi
                self.tableView.reloadSections([0], with: .none)
            }
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 // Sesuaikan tinggi header sesuai kebutuhan
    }
    
    
}
