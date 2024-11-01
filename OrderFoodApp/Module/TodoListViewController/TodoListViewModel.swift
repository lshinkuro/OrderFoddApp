//
//  TodoListViewModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 22/10/24.
//

import Foundation

protocol ViewModelProtocol {
    var isFiltered: Bool { get set }
    var filteredDataList: [ChartModel] { get set }

    func  calculatePayment() -> Double
}


class TodoListViewModel: ViewModelProtocol {
    
    func calculatePayment() -> Double {
        return 0.0
    }
    
    var isFiltered: Bool = false
    var filteredDataList: [ChartModel] = []
    
    
    var onUpdateData: ((String) -> Void)?
}
