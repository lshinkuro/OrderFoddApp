//
//  FilterViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 17/11/24.
//

import Foundation
import UIKit
import SnapKit



// MARK: - FilterSection.swift
enum FilterSection: Int, CaseIterable {
    case priceRange
    case discount
    case brand
    case features
    case connectivity
    
    var title: String {
        switch self {
        case .priceRange: return "Price Range"
        case .discount: return "Discount"
        case .brand: return "Brand"
        case .features: return "Features"
        case .connectivity: return "Connectivity Technology"
        }
    }
}

// MARK: - FilterViewController.swift
final class FilterViewController: UIViewController {
    // MARK: - Properties
    private let filterManager = FilterManager.shared
    public var heightFPC = CustomObservable<CGFloat>()

    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(SliderTableViewCell.self, forCellReuseIdentifier: "SliderCell")
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: "CollectionCell")
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .systemBackground
        table.separatorStyle = .none
        return table
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Dummy Data
    private let brandFilters: [FilterModel] = brandDataFilters
    private let featuresFilters: [FilterModel] = featuresDataFilters
    private let connectivityFilters: [FilterModel] = connectivityDataFilters
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.heightFPC.observer = getHeightOfViewController()
    }
    
    private func getHeightOfViewController() -> CGFloat {
        let totalHeight = view.frame.height - 55.0
        return totalHeight
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Filters"
        
        view.addSubview(tableView)
        view.addSubview(bottomView)
        bottomView.addSubview(buttonStackView)
        [resetButton, applyButton].forEach { buttonStackView.addArrangedSubview($0) }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    // MARK: - Actions
    @objc private func resetTapped() {
        filterManager.reset()
        tableView.reloadData()
    }
    
    @objc private func applyTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return FilterSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FilterSection(rawValue: section)?.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = FilterSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .priceRange, .discount:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell", for: indexPath) as? SliderTableViewCell else {
                return UITableViewCell()
            }
            
            let isPrice = section == .priceRange
            cell.configure(
                minValue: isPrice ? 1299 : 0,
                maxValue: isPrice ? 3999 : 100,
                currentValue: isPrice ? Float(filterManager.priceRange.max) : Float(filterManager.discount)
            ) { [weak self] value in
                if isPrice {
                    self?.filterManager.priceRange.max = Double(value)
                } else {
                    self?.filterManager.discount = Double(value)
                }
            }
            return cell
            
        case .brand, .features, .connectivity:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as? CollectionTableViewCell else {
                return UITableViewCell()
            }
            
            let filters: [FilterModel]
            let selectedItems: Set<String>
            
            switch section {
            case .brand:
                filters = brandFilters
                selectedItems = filterManager.selectedBrands
            case .features:
                filters = featuresFilters
                selectedItems = filterManager.selectedFeatures
            case .connectivity:
                filters = connectivityFilters
                selectedItems = filterManager.selectedConnectivity
            default:
                return cell
            }
            
            cell.configure(with: filters, selectedItems: selectedItems) { [weak self] title, isSelected in
                switch section {
                case .brand:
                    if isSelected {
                        self?.filterManager.selectedBrands.insert(title)
                    } else {
                        self?.filterManager.selectedBrands.remove(title)
                    }
                case .features:
                    if isSelected {
                        self?.filterManager.selectedFeatures.insert(title)
                    } else {
                        self?.filterManager.selectedFeatures.remove(title)
                    }
                case .connectivity:
                    if isSelected {
                        self?.filterManager.selectedConnectivity.insert(title)
                    } else {
                        self?.filterManager.selectedConnectivity.remove(title)
                    }
                default:
                    break
                }
            }
            return cell
        }
    }
}

// MARK: - FilterTableViewDelegate
extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = FilterSection(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .priceRange, .discount:
            return 40
        case .brand:
            return CGFloat(ceil(Double(brandFilters.count) / 3.0) * 30) + 15 // Calculate height based on number of items
        case .features:
            return CGFloat(ceil(Double(featuresFilters.count) / 3.0) * 44) + 15
        case .connectivity:
            return CGFloat(ceil(Double(connectivityFilters.count) / 3.0) * 48) + 40
        }
    }
}




