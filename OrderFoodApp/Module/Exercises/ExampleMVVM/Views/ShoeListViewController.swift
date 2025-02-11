//
//  ShoeListViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 21/01/25.
//

import UIKit

class ShoeListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let loadingLabel = UILabel()
    private let emptyLabel = UILabel()
    private let errorLabel = UILabel()
    
    private let viewModel = ShoeListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchShoeItems()
    }
    
    private func setupUI() {
        title = "Food List"
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
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FoodCell")
    
        view.add(loadingLabel, emptyLabel, errorLabel, tableView)
        
        loadingLabel.frame = view.bounds
        emptyLabel.frame = view.bounds
        errorLabel.frame = CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: 100)
        tableView.frame = view.bounds
    }
    
}

extension ShoeListViewController {

    
    private func setupBindings() {
        viewModel.onStateChange = { [weak self] state in
            guard let self = self else { return }
            self.updateUI(for: state)
        }
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
            tableView.reloadData()
        case .empty:
            emptyLabel.isHidden = false
        case .error(let message):
            errorLabel.isHidden = false
            errorLabel.text = "Error: \(message)"
        }
    }
}

extension ShoeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.shoeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
        let item = viewModel.shoeItems[indexPath.row]
        cell.textLabel?.text = item.name
        cell.accessoryType = item.isFavorite ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.shoeItems[indexPath.row]
        let detailVC = ShoeDetailViewController(viewModel: ShoeDetailViewModel(shoeItem: item))
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
