//
//  FeatureListViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 17/01/25.
//

import UIKit
import SnapKit

class FeatureListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let features = [
        "Profile Page",
        "Filter Page",
        "Tooltip Page",
        "Diffabel Table Page",
        "Tab Collection Page",
        "Example Grid",
        "Example Homepage Bank",
        "Example Multiple Filter",
        "Step Question",
        "Tinder Swipe",
        "QR Code",
        "Example 3D",
        "Example Web Socket",
        "Mapkit",
        "URL Session implement",
        "Gesture Animation",
        "Example Coachmark",
        "Example Crypto",
        "Todo List Firestore",
        "Animation",
        "Compositional",
        "Onirix",
        "Mix UIKit & Swift UI",
        "XChange Rate",
        "Snapkit",
        "RX Swift",
        "Example MVVM",
        "Payment Methode",
        "Advanced TableView",
        "Advanced CollectionView",
        "Terms Agreement"
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    private func setupUI() {
        title = "Feature List"
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        // Menggunakan SnapKit untuk pengaturan layout
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeatureCell.self, forCellReuseIdentifier: "FeatureCell")
    }
}

extension FeatureListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as! FeatureCell
        cell.textLabel?.text = features[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedFeature = features[indexPath.row]
        let nextViewController: UIViewController
        
        switch selectedFeature {
        case "Profile Page":
            nextViewController = ProfileViewController()
        case "Filter Page":
            nextViewController = FilterViewController()
        case "Settings Page":
            nextViewController = TooltipViewController()
        case "Diffabel Table Page":
            nextViewController = BookStoreViewController()
        case "Tab Collection Page":
            nextViewController = ExampleTabCollectionViewController()
        case "Tooltip Page":
            nextViewController = TooltipViewController()
            
        case "Example Grid":
            nextViewController = PromoViewControllerV2()

        case "Example Homepage Bank":
            nextViewController = ExampleHomepageBankApp()

        case "Example Multiple Filter":
            nextViewController = FilterViewController()

        case "Step Question":
            nextViewController = StepQuestionViewController()

        case "Tinder Swipe":
            nextViewController = SwipeCardViewController()

        case "QR Code":
            nextViewController = QRCodeScanViewController()

        case "Example 3D":
            nextViewController = Example3DViewController()
        case "Example Web Socket":
            nextViewController = RealTimeStockViewController()
        case "Mapkit":
            nextViewController = MapKitViewController()
        case "URL Session implement":
            nextViewController = URLSessionViewController()
            
        case "Gesture Animation":
            nextViewController = URLSessionViewController()
        case "Example Coachmark":
            nextViewController = ExampleCoachmarkViewController()
        case "Example Crypto":
            nextViewController = ExampleCryptoKitViewController()
        case "Todo List Firestore":
            nextViewController = TodoListFireStoreViewController()
        case "Animation":
            nextViewController = AnimationViewController()
        case "Compositional":
            nextViewController = HomePageBankViewController()
        case "Onirix":
            nextViewController = OnirixWebViewController()
        case "Mix UIKit & Swift UI":
//            nextViewController = MixSwiftUIViewController()
            nextViewController = ExampleInjectSwiftUIVC()
        case "XChange Rate":
            nextViewController = MoneyExchangeViewController()
        case "Snapkit":
            nextViewController = ExampleSnapkitViewController()
        case "RX Swift":
            nextViewController = RxSwiftImplementationViewController()
        case "Example MVVM":
            nextViewController = ShoeListViewController()
        case "Payment Methode":
            nextViewController = PaymentMethodViewController()
        case "Advanced TableView":
            nextViewController = MultipleCustomCellViewController()
            
        case "Advanced CollectionView":
            nextViewController = CompositionalCollectionViewViewController()
        case "Terms Agreement":
            nextViewController = TermsAgreementVC()

            
        default:
            return
        }
        
        nextViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

// MARK: - FeatureCell
class FeatureCell: UITableViewCell {
    static let identifier = "FeatureCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        
        // Layout titleLabel dengan SnapKit
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        accessoryType = .disclosureIndicator
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
