//
//  ShopV3ViewModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 27/03/25.
//

import RxSwift
import RxCocoa
import UIKit

enum ShopV3Section: CaseIterable {
    case offerGeneral
    case productList
    case promotion
    
    func cellTypes() -> [(UITableViewCell.Type, String)] {
        switch self {
        case .offerGeneral:
            return [(OfferTableViewCell.self, "OfferCell")]
        case .productList:
            return [(ProductTableViewCell.self, "ProductCell")]
        case .promotion:
            return [(PromotionTableViewCell.self, "PromotionCell")]
        }
    }
    
    static func allCellTypes() -> [(UITableViewCell.Type, String)] {
        let baseCells: [(UITableViewCell.Type, String)] = [
            (SkeletonTableViewCell.self, "SkeletonCell"),
            (ErrorTableViewCell.self, "ErrorCell")
        ]
        return ShopV3Section.allCases.flatMap { $0.cellTypes() } + baseCells
    }
}


class ShopV3ViewModel {
    private let disposeBag = DisposeBag()
    
    // Output yang akan dipakai di Controller
    let dataSource = BehaviorRelay<[[ShopV3CellType]]>(value: [])
    
    // State untuk error dan loading
    let isLoading = BehaviorRelay<Bool>(value: true)
    let hasError = BehaviorRelay<Bool>(value: false)
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        isLoading.accept(true)
        hasError.accept(false)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            let mockData: [[ShopV3CellType]] = [
                [.offer(OfferModel(title: "Flash Sale", discount: "50% OFF"))],
                [.product(ProductModel(name: "Nike Shoes", price: "$120"))],
                [.promotion(PromotionModel(bannerImage: "promo_banner"))]
            ]
            
            DispatchQueue.main.async {
                self.isLoading.accept(false)
                self.dataSource.accept(mockData)
            }
        }
    }
}
