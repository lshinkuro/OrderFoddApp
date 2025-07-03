//
//  ExampleHomepageBankApp.swift
//  OrderFoodApp
//
//  Created by Phincon on 18/12/24.
//

import Foundation
import UIKit
import SnapKit

// MARK: - Models
struct TransactionBank {
    let icon: String
    let title: String
    let date: String
    let amount: Double
}

struct MenuItem {
    let icon: String
    let title: String
}

// MARK: - ViewControllers
final class ExampleHomepageBankApp: UIViewController {
    // MARK: - Properties
    private let balanceView = BalanceView()
    private let menuCollectionView: UICollectionView
    private let transactionCollectionView: UICollectionView
    
    private var menuItems: [MenuItem] = [
        MenuItem(icon: "arrow.up", title: "Pay"),
        MenuItem(icon: "arrow.down", title: "Receive"),
        MenuItem(icon: "doc.text", title: "Bills"),
        MenuItem(icon: "arrow.left.arrow.right", title: "Transaction"),
        MenuItem(icon: "dollarsign.circle", title: "Loans"),
        MenuItem(icon: "creditcard", title: "Credit Card"),
        MenuItem(icon: "circle.grid.2x2", title: "Mutual Fund"),
        MenuItem(icon: "chart.bar", title: "Fixed Deposits")
    ]
    
    private var transactions: [TransactionBank] = [
        TransactionBank(icon: "dollarsign.circle", title: "Cash Withdrawal", date: "10:30 23 Aug", amount: 304),
        TransactionBank(icon: "checkmark.circle", title: "Payment", date: "11:45 23 Aug", amount: 500),
        TransactionBank(icon: "cart", title: "Grocery Store", date: "12:30 23 Aug", amount: 56),
        TransactionBank(icon: "repeat", title: "Monthly Subscribe", date: "14:20 23 Aug", amount: 23)
    ]
    
    // MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        menuCollectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.createMenuLayout())
        transactionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.createTransactionLayout())
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionViews()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(balanceView)
        view.addSubview(menuCollectionView)
        view.addSubview(transactionCollectionView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        balanceView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(150)
        }
        
        menuCollectionView.snp.makeConstraints { make in
            make.top.equalTo(balanceView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
        
        transactionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(menuCollectionView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Collection View Setup
extension ExampleHomepageBankApp {
    private func setupCollectionViews() {
        setupMenuCollectionView()
        setupTransactionCollectionView()
    }
    
    private func setupMenuCollectionView() {
        menuCollectionView.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.reuseIdentifier)
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.backgroundColor = .clear
    }
    
    private func setupTransactionCollectionView() {
        transactionCollectionView.register(TransactionBankCell.self, forCellWithReuseIdentifier: TransactionBankCell.reuseIdentifier)
        transactionCollectionView.delegate = self
        transactionCollectionView.dataSource = self
        transactionCollectionView.backgroundColor = .clear
    }
    
    private static func createMenuLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                     subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private static func createTransactionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .absolute(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                   subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - UICollectionViewDataSource
extension ExampleHomepageBankApp: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuCollectionView {
            return menuItems.count
        } else {
            return transactions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.reuseIdentifier, for: indexPath) as! MenuCell
            let item = menuItems[indexPath.item]
            cell.configure(with: item)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionBankCell.reuseIdentifier, for: indexPath) as! TransactionBankCell
            let transaction = transactions[indexPath.item]
            cell.configure(with: transaction)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ExampleHomepageBankApp: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle selection
    }
}

// MARK: - Custom Views
final class BalanceView: UIView {
    private let nameLabel = UILabel()
    private let balanceLabel = UILabel()
    private let balanceAmountLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBlue
        layer.cornerRadius = 16
        
        addSubview(nameLabel)
        addSubview(balanceLabel)
        addSubview(balanceAmountLabel)
        addSubview(descriptionLabel)
        
        nameLabel.text = "Nick Julian"
        nameLabel.textColor = .white
        
        balanceLabel.text = "Current Balance"
        balanceLabel.textColor = .white
        
        balanceAmountLabel.text = "$ 1,245"
        balanceAmountLabel.textColor = .white
        balanceAmountLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        descriptionLabel.text = "Lorem ipsum dolor sit amet"
        descriptionLabel.textColor = .white.withAlphaComponent(0.8)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        balanceAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(balanceLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(balanceAmountLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
    }
}

// MARK: - Collection View Cells
final class MenuCell: UICollectionViewCell {
    static let reuseIdentifier = "MenuCell"
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBlue.withAlphaComponent(0.1)
        layer.cornerRadius = 12
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        iconImageView.tintColor = .systemBlue
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 12)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(4)
        }
    }
    
    func configure(with item: MenuItem) {
        iconImageView.image = UIImage(systemName: item.icon)
        titleLabel.text = item.title
    }
}

final class TransactionBankCell: UICollectionViewCell {
    static let reuseIdentifier = "TransactionBankCell"
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let amountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountLabel)
        
        iconImageView.tintColor = .systemBlue
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .systemGray
        amountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(12)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with transaction: TransactionBank) {
        iconImageView.image = UIImage(systemName: transaction.icon)
        titleLabel.text = transaction.title
        dateLabel.text = transaction.date
        amountLabel.text = "$ \(transaction.amount)"
    }
}

