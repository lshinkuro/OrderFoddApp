//
//  FeatureListViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 17/01/25.
//

import UIKit
import SnapKit

enum FeatureTypeSection: String, CaseIterable {
    case cellModel
    case detailPackage
    case profilePage
    case filterPage
    case tooltipPage
    case diffabelTablePage
    case tabCollectionPage
    case exampleGrid
    case exampleHomepageBank
    case exampleMultipleFilter
    case stepQuestion
    case tinderSwipe
    case qrCode
    case example3D
    case exampleWebSocket
    case mapkit
    case urlSessionImplement
    case gestureAnimation
    case exampleCoachmark
    case exampleCrypto
    case todoListFirestore
    case animation
    case compositional
    case onir
    case mixUIKitAndSwiftUI
    case xchangeRate
    case Snapkit
    case RXSwift
    case exampleMVVM
    case paymentMethode
    case advancedTableView
    case advancedCollectionView
    case termsAgreement
    case entertainmentCommerce
    case NSAttributedString
    
    var description: String {
        switch self {
        case .cellModel: return "Cell Model"
        case .detailPackage: return "Detail Package"
        case .profilePage: return "Profile Page"
        case .filterPage: return "Filter Page"
        case .tooltipPage: return "Tooltip Page"
        case .diffabelTablePage: return "Diffabel Table Page"
        case .tabCollectionPage: return "Tab Collection Page"
        case .exampleGrid: return "Example Grid"
        case .exampleHomepageBank: return "Example Homepage Bank"
        case .exampleMultipleFilter: return "Example Multiple Filter"
        case .stepQuestion: return "Step Question"
        case .tinderSwipe: return "Tinder Swipe"
        case .qrCode: return "QR Code"
        case .example3D: return "Example 3D"
        case .NSAttributedString: return "NSAttributedString"
        case .exampleWebSocket: return "Example Web Socket"
        case .mapkit: return "Mapkit"
        case .urlSessionImplement: return "URL Session implement"
        case .gestureAnimation: return "Gesture Animation"
        case .exampleCoachmark: return "Example Coachmark"
        case .exampleCrypto: return "Example Crypto"
        case .todoListFirestore: return "Todo List Firestore"
        case .animation:
            return "Animation"
        case .compositional:
            return "Compositional"
        case .onir:
            return "Onirix"
        case .mixUIKitAndSwiftUI:
            return "Mix UIKit & Swift UI"
        case .xchangeRate:
            return "Xchange Rate"
        case .Snapkit:
            return "snapkit"
        case .RXSwift:
            return "Rx Swift"
        case .exampleMVVM:
            return "Example MVVM"
        case .paymentMethode:
            return "Payment Methode"
        case .advancedTableView:
            return "Advanced Table View"
        case .advancedCollectionView:
            return "Advanced Collection View"
        case .termsAgreement:
            return "Terms Agreement"
        case .entertainmentCommerce:
            return "Entertainment & Commerce"
        }
    }
    
}

class FeatureListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let features = [
        "Cell Model",
        "Detail Package",
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
        "Terms Agreement",
        "Entertainment Commerce",
        "NSAttributedString (iOS 13+)"
        
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
        case "Cell Model":
            nextViewController = ShopV3ViewController()
        case "Detail Package":
            nextViewController = DetailPackageViewController()
        case "Profile Page":
            nextViewController = GradientTextAnimationViewController()
        case "Filter Page":
            nextViewController = FilterViewController()
        case "Settings Page":
            nextViewController = UIViewController()
        case "Diffabel Table Page":
            nextViewController = BookStoreViewController()
        case "Tab Collection Page":
            nextViewController = ExampleTabCollectionViewController()
        case "Tooltip Page":
            nextViewController = UIViewController()
            
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
            nextViewController = UIViewController()
        case "Mapkit":
            nextViewController = UIViewController()
        case "URL Session implement":
            nextViewController = URLSessionViewController()
            
        case "Gesture Animation":
            nextViewController = URLSessionViewController()
        case "Example Coachmark":
            nextViewController = UIViewController()
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
        case "Entertainment Commerce":
            //            nextViewController = EntertainmentCommerceViewController()
            nextViewController = ImageDownloadViewController()
        case "NSAttributedString (iOS 13+)":
            //            nextViewController = EntertainmentCommerceViewController()
            nextViewController = NSAttributeViewController()
            
            
            
        default:
            return
        }
        
        nextViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushFromBottom(nextViewController)
        //        navigationController?.pushViewController(nextViewController, animated: true)
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
