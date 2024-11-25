//
//  HomePageBankViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/11/24.
//

import Foundation
import UIKit
import SnapKit

enum SectionBankType: Int {
    case header
    case balance
    case expenses
    case pendingTransaction
    case transactions
}

enum ItemType: Hashable {
    case header(String, String)
    case balance(BalanceModel)
    case expenses(ExpensesModel)
    case pending(TransactionModel)
    case transactions(TransactionModel)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .header(let name, let image):
            hasher.combine(name)
            hasher.combine(image)
        case .balance(let balance):
            hasher.combine(balance.cardNumber)
        case .expenses(let expenses):
            hasher.combine(expenses.expense)
            hasher.combine(expenses.income)
        case .pending(let transaction), .transactions(let transaction):
            hasher.combine(transaction.id)
        }
    }
    
    static func == (lhs: ItemType, rhs: ItemType) -> Bool {
        switch (lhs, rhs) {
        case (.header(let lName, let lImage), .header(let rName, let rImage)):
            return lName == rName && lImage == rImage
        case (.balance(let lBalance), .balance(let rBalance)):
            return lBalance.cardNumber == rBalance.cardNumber
        case (.expenses(let lExpenses), .expenses(let rExpenses)):
            return lExpenses.expense == rExpenses.expense && lExpenses.income == rExpenses.income
        case (.pending(let lTransaction), .pending(let rTransaction)):
            return lTransaction.id == rTransaction.id
        case (.transactions(let lTransaction), .transactions(let rTransaction)):
            return lTransaction.id == rTransaction.id
        default:
            return false
        }
    }
}

class HomePageBankViewController: BaseViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SectionBankType, ItemType>?
    
    private var viewModel = HomePageBankViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureDataSource()
        bindingData()
    }
    
    func bindingData() {
        viewModel.getData()
        
        viewModel.bankData
            .asObservable()
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                guard let dataItem = data else { return }
                DispatchQueue.main.async {
                    print(dataItem)
                    self.updateSnapshot(with: dataItem)
                }
            }).disposed(by: disposeBag)
        
        viewModel.loadingState.asObservable().subscribe(onNext: { [weak self] loading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch loading {
                case .loading:
                    print("loading")
                case .failed:
                    print("gagal request")
                    // Show error alert
                    let alert = UIAlertController(title: "Error",
                                                  message: "error aja",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                case .finished:
                    print("selesai request")
                default:
                    break
                }
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.reuseIdentifier)
        collectionView.register(BalanceCell.self, forCellWithReuseIdentifier: BalanceCell.reuseIdentifier)
        collectionView.register(ExpensesCell.self, forCellWithReuseIdentifier: ExpensesCell.reuseIdentifier)
        collectionView.register(PendingTransactionCell.self, forCellWithReuseIdentifier: PendingTransactionCell.reuseIdentifier)
        collectionView.register(TransactionCell.self, forCellWithReuseIdentifier: TransactionCell.reuseIdentifier)
    }
}

// MARK: - CompositionalLayout.swift
extension HomePageBankViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = SectionBankType(rawValue: sectionIndex) else { return nil}
            
            switch section {
            case .header:
                return LayoutSection.headerSection()
            case .balance:
                return LayoutSection.balanceSection()
            case .expenses:
                return LayoutSection.expensesSection()
            case .pendingTransaction:
                return LayoutSection.pendingSection()
            case .transactions:
                return LayoutSection.transactionsSection()
            }
        }
        return layout
    }
}

// MARK: - MainViewController Extension
extension HomePageBankViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionBankType, ItemType>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, item in
            switch item {
            case .header(let name, let imageUrl):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.reuseIdentifier, for: indexPath) as! HeaderCell
                cell.configure(with: name, imageUrl: imageUrl)
                return cell
                
            case .balance(let balance):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BalanceCell.reuseIdentifier, for: indexPath) as! BalanceCell
                cell.configure(with: balance)
                return cell
                
            case .expenses(let expense):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpensesCell.reuseIdentifier, for: indexPath) as! ExpensesCell
                cell.configure(with: expense)
                return cell
                
            case .pending(let transaction):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PendingTransactionCell.reuseIdentifier, for: indexPath) as! PendingTransactionCell
                cell.configure(with: transaction)
                return cell
                
            case .transactions(let transaction):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionCell.reuseIdentifier, for: indexPath) as! TransactionCell
                cell.configure(with: transaction)
                return cell
            }
        }
    }
    
    func updateSnapshot(with data: BankingData) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionBankType, ItemType>()
        
        // Add sections and items
        snapshot.appendSections([.header])
        snapshot.appendItems([.header(data.user.name, data.user.profileImage)])
        
        snapshot.appendSections([.balance])
        snapshot.appendItems([.balance(data.balance)])
        
        snapshot.appendSections([.expenses])
        snapshot.appendItems([.expenses(data.expenses)])
        
        snapshot.appendSections([.pendingTransaction])
        let pendingItems = data.pendingTransactions.map { ItemType.pending($0) }
        snapshot.appendItems(pendingItems)
        
        snapshot.appendSections([.transactions])
        let transactionItems = data.recentTransactions.map {
            ItemType.transactions($0)
        }
        snapshot.appendItems(transactionItems)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate
extension HomePageBankViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .header(let name, let imageUrl):
            
            print(name)
            
        case .balance(let balance):
            
            print(balance)
            
        case .expenses(let expenses):
            
            print(expenses)
            
        case .pending(let transaction):
            
            print(transaction)
            
        case .transactions(let transaction):
            print(transaction)
        }
        
        // Optional: Deselect item after handling
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}



