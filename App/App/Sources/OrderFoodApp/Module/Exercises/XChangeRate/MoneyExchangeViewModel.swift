//
//  MoneyExchangeViewModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 29/11/24.
//

import Foundation
import RxSwift
import RxRelay

class MoneyExchangeViewModel {
    let amount = BehaviorRelay<Double>(value: 0)
    let exchangeRate = BehaviorRelay<Double>(value: 84.83)
    let fee = BehaviorRelay<Double>(value: 2.00)
    
    let convertedAmount: Observable<Double>
    
    init() {
        convertedAmount = Observable.combineLatest(amount, exchangeRate)
            .map { amount, rate in
                return amount * rate
            }
    }
}
