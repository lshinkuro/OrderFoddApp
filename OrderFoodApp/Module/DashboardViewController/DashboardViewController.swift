//
//  DashboardViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import UIKit
import SwiftUI
import RxSwift
import SkeletonView
import Toast

/*@available(iOS 13.0, *)
 struct ViewController_Previews: PreviewProvider {
 static var previews: some View {
 previewViewController(DashboardViewController())
 }
 }*/

enum FoodDashboardType: Int , CaseIterable{
    case category = 0
    case itemCategory
    case promo
    case ads
    case special
}

class DashboardViewController: BaseViewController {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var currentItems: [FoodItem] = []
    
    var dataFood: FoodModel? {
        didSet {
            if let data = dataFood?.foodData {
                self.foodsData = data
                self.currentItems = data.first?.items ?? []
            }
        }
    }
    
    var foodsData: [FoodCategoryData] = []
    var selectedCategory: FoodCategory = .pizza
    let vm = DashboardViewModel()
    
    let floatingIcon = FloatingIconView(image: UIImage(named: "promo1")!)
    lazy var emptyStateView = ErrorView(frame: tableView.frame)
    
    var coordinator: DashboardCoordinator?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateFoodItems(for: selectedCategory)
        setupFloatingIcon()
        bindingData()
        setupRefreshControl()
        receiveNotifCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        vm.fetchAllMenu()
        emptyStateView.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func hideNavigationBar(){
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = true
        self.hidesBottomBarWhenPushed = false
    }
    
    func receiveNotifCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotif(_:)), name: .NotifData, object: nil)
    }
    
    @objc func handleNotif(_ notification: Notification) {
        if let userInfo = notification.userInfo, let message = userInfo["message"] as? String {
            print("Notification received with message: \(message)")
            let config = ToastViewConfiguration(subtitleNumberOfLines: 0)
            let toast = Toast.default(
                image: UIImage(named: "ads1")!,
                title: "test notif",
                subtitle: "\(message)",
                viewConfig: config
            )
            toast.show(after: 0.3)
        }
    }
    
    func bindingData() {
        vm.foodsModel.asObservable().subscribe(onNext: { [weak self] result in
            guard let self = self, let validData = result else {
                return }
            self.dataFood = validData
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .notLoad, .loading:
                    self.tableView.showAnimatedGradientSkeleton()
                case .finished:
                    self.tableView.hideSkeleton()
                case .failed:
                    self.tableView.hideSkeleton()
                    self.updateEmptyStateView(isShow: true)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func setup() {
        tableView.registerCellWithNib(FoodItemCategoryTableViewCell.self)
        tableView.registerCellWithNib(FoodItemDetailTableViewCell.self)
        tableView.registerCellWithNib(PromoFoodTableViewCell.self)
        tableView.registerCellWithNib(AdsFoodTableViewCell.self)
        tableView.registerCellWithNib(SpecialForYouTableViewCell.self)

        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        menuButton.addTarget(self, action: #selector(actionTapMenu), for: .touchUpInside)
        
    }
    
    
    
    @objc func actionTapMenu() {
        let vc = LeftMenuSheetViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    func updateFoodItems(for category: FoodCategory) {
        if let selectedData = foodsData.first(where: { $0.category == category }) {
            currentItems = selectedData.items
            tableView.reloadData()
        }
    }
    
    
    private func updateEmptyStateView(isShow: Bool) {
        tableView.isHidden = isShow
        shouldShowErrorView(status: isShow)
    }
    
    func shouldShowErrorView(status: Bool) {
        switch status {
        case true:
            if !view.subviews.contains(emptyStateView) {
                view.addSubview(emptyStateView)
            } else {
                emptyStateView.isHidden = false
            }
        case false:
            if view.subviews.contains(emptyStateView) {
                emptyStateView.isHidden = true
            }
        }
    }
    
    // Setup Refresh Control
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // Refresh handler
    @objc func refreshTableData() {
        vm.fetchAllMenu()
    }
    
}

// MARK: setupFloatingIcon
extension DashboardViewController: FloatingIconViewDelegate {
    func actionTap() {
        // Contoh: animasi bouncing saat di-tap
        UIView.animate(withDuration: 0.4) {
            self.floatingIcon.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.floatingIcon.transform = CGAffineTransform(rotationAngle: 40)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.floatingIcon.transform = CGAffineTransform.identity
            }
        }
    }
    
    func setupFloatingIcon() {
        self.view.addSubview(floatingIcon)
        self.floatingIcon.delegate = self
    }
    
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return FoodDashboardType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellType = FoodDashboardType(rawValue: section)
        switch cellType {
        case .category, .itemCategory, .special:
            return 1
        case .promo:
            if let dataPromo = dataFood?.promoData {
                return dataPromo.count > 0 ? 1 : 0
            } else {
                return 0
            }
        case .ads:
            return dataFood?.adsData.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = FoodDashboardType(rawValue: indexPath.section)
        switch cellType {
        case .category:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FoodItemCategoryTableViewCell
            cell.categoryItems = foodsData
            cell.onSelectCategory = { [weak self] category in
                guard let self = self else { return }
                self.updateFoodItems(for: category)
            }
            return cell
        case .itemCategory:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FoodItemDetailTableViewCell
            cell.items = currentItems
            cell.onSelectItem = { item in
                self.navigateToDetail(foodItem: item)
            }
            return cell
        case .promo:
            guard let promoData = dataFood?.promoData else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PromoFoodTableViewCell
            cell.dataPromo = promoData
            return cell
        case .ads:
            guard let adsData = dataFood?.adsData else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AdsFoodTableViewCell
            cell.configure(data: adsData[indexPath.row])
            return cell
        case .special:
            guard let special = dataFood?.special else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SpecialForYouTableViewCell
            cell.specialData = special
            cell.layoutIfNeeded()
            cell.heighTableView.constant = cell.tableView.contentSize.height
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = FoodDashboardType(rawValue: indexPath.section)
        switch cellType {
        case .category, .itemCategory, .promo, .ads, .special:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellType = FoodDashboardType(rawValue: section)
        switch cellType {
        case .category, .itemCategory, .promo:
            return nil
        case .ads:
            let headerView = CustomHeaderSectionCell(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
            headerView.configure(with: "ads1", title: "This is an Ads Section")
            return headerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cellType = FoodDashboardType(rawValue: section)
        switch cellType {
        case .ads:
            return 60
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = FoodDashboardType(rawValue: indexPath.section)
        switch cellType {
        case .ads:
            guard let adsData = dataFood?.adsData else { return }
            let vc = AdsViewController()
            vc.url = adsData[indexPath.row].urlString
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated:true)
        default:
            break
        }
    }
}

extension DashboardViewController: SkeletonTableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return 4
        default:
            return 0
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch indexPath.section {
        case 0: return "FoodItemCategoryTableViewCell"
        case 1: return "FoodItemDetailTableViewCell"
        case 2: return "PromoFoodTableViewCell"
        case 3: return "AdsFoodTableViewCell"
        default:
            return "AdsFoodTableViewCell"
        }
    }
}

extension DashboardViewController {
    func navigateToDetail(foodItem: FoodItem?) {
        self.coordinator?.showDetail(with: foodItem)
        
//        let vc = DetailFoodItemViewController()
//        vc.foodItem = foodItem
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DashboardViewController: ErrorViewDelegate {
    func tapButton() {
        self.updateEmptyStateView(isShow: false)
        self.vm.fetchAllMenu()
    }
}
