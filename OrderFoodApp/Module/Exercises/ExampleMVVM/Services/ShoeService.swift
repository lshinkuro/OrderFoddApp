//
//  ShoeService.swift
//  OrderFoodApp
//
//  Created by Phincon on 21/01/25.
//

import Foundation
import RxSwift

protocol ShoeServiceProtocol {
    func fetchShoeItems() -> Observable<[ShoeItem]>
}

class ShoeService: ShoeServiceProtocol {
    func fetchShoeItems() -> Observable<[ShoeItem]> {
        return Observable.create { observer in
            DispatchQueue.global().asyncAfter(deadline: .now() + 4) {
                let items = [
                    ShoeItem(id: 1, name: "Brodo", description: "Modern Shoe Trendy", isFavorite: false),
                    ShoeItem(id: 2, name: "Canvas", description: "Luxury Design Sporty", isFavorite: true),
                    ShoeItem(id: 3, name: "Adidas", description: "Modern Casual Vintage", isFavorite: false)
                ]
                
                // Emit data
                observer.onNext(items)
                
                // Emit completion
                observer.onCompleted()
                
                // Simulate empty state
//                observer.onNext([])
//                observer.onCompleted()
                
                // Simulate error
//                observer.onError(NSError(domain: "Network Error", code: -1, userInfo: nil))
            }
            
            return Disposables.create()
        }
    }
}


