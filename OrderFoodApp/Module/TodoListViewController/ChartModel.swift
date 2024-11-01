//
//  ChartModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import Foundation


struct ChartModel {
    var image: String
    var title: String
    var description: String
    var age: Int
}

class ChartList {
    
    static let shared = ChartList()
    private init() {}
    
    var dataList: [ChartModel] = []
    
    func addPerson(person: ChartModel) {
        dataList.append(person)
    }
    
    func editPerson(idx: Int, person: ChartModel) {
        dataList[idx] = person
    }
    
    func removePersonAt(idx: Int) {
        self.dataList.remove(at: idx)
    }
    
    // Sort by title alphabetically
     func sortByTitle() {
         dataList.sort { $0.title.lowercased() < $1.title.lowercased() }
     }
     
     // Find by name
     func findByName(name: String) -> [ChartModel] {
         return dataList.filter { $0.title.lowercased().contains(name.lowercased()) }
     }
     
     // Filter by age range
     func filterByAge(minAge: Int, maxAge: Int) -> [ChartModel] {
         return dataList.filter { $0.age >= minAge && $0.age <= maxAge }
     }
    
}
