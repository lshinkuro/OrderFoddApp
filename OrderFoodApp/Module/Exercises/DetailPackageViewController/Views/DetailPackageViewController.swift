//
//  DetailPackageViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 18/03/25.
//

import Foundation
import UIKit
import SnapKit
import SwiftUI



class DetailPackageViewController: BaseViewController {
    
    
    private let backgroundImageView: UIImageView = UIImageView().configure {
        $0.image = UIImage(named: "background_red")
        $0.contentMode = .scaleAspectFill
        $0.makeCornerRadius(16, maskedCorner: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        
    }
    
    private let tableView: UITableView = UITableView().configure{
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }
    
    var viewModel: DetailPackageViewModel
    let graphView = MultiDataCircularGraph()
    
    private let paymentSummaryView = DetailPackagePriceBottomView()
    
    
    
    init(viewModel: DetailPackageViewModel = DetailPackageViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension DetailPackageViewController {
    private func setup() {
        title = "Detail Package"
        view.add(backgroundImageView,tableView)
        
        backgroundImageView.snapshotView(afterScreenUpdates: false)
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileekycCell.self, forCellReuseIdentifier: "ProfileekycCell")
        tableView.register(PackageDetailCell.self, forCellReuseIdentifier: PackageDetailCell.reuseIdentifier)
        tableView.register(ExtraQuotaCell.self, forCellReuseIdentifier: ExtraQuotaCell.reuseIdentifier)
        tableView.register(PurchaseOptionCell.self, forCellReuseIdentifier: PurchaseOptionCell.reuseIdentifier)
        tableView.register(AddOnTableViewCell.self, forCellReuseIdentifier: AddOnTableViewCell.reuseIdentifier)
        
        // Tambahkan ini untuk auto height
        tableView.rowHeight = UITableView.automaticDimension
        
        graphView.snp.makeConstraints { make in
            make.height.equalTo(150) // Atur tinggi sesuai kebutuhan
        }
        
        // Add payment summary view
        view.addSubview(paymentSummaryView)
        
        // Position it near the bottom with proper margin
        paymentSummaryView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // Make sure it's brought to front
        view.bringSubviewToFront(paymentSummaryView)
        
        
    }
    
    
}
